const { TextToSpeechClient } = require('@google-cloud/text-to-speech')
const mkdir = require('make-dir')

const fs = require('fs')
const util = require('util')
const childProcess = require('child_process')
const writeFile = util.promisify(fs.writeFile)
const exec = util.promisify(childProcess.exec)
const argv = require('minimist')(process.argv.slice(2))
const toml = require('@iarna/toml')
const config = toml.parse(fs.readFileSync('config.toml', { encoding: 'UTF-8' }))

const client = new TextToSpeechClient({
	keyFilename: config.otemot.google_credentials
})
const text = argv._[0]
const name = argv.n

const rq = {
	input: { text },
	voice: { languageCode: 'en-US', name: 'en-US-Standard-B' },
	audioConfig: {
		audioEncoding: 'MP3',
		pitch: argv.p || 0,
		speakingRate: argv.s || 1.0
	}
}

mkdir(`${__dirname}/gentts/${name}`).then(() => {
	console.log('synthesizing speech...')
	return client.synthesizeSpeech(rq)
}).then(response => {
	console.log('writing audio...')
	return writeFile(`${__dirname}/gentts/${name}/temp.mp3`, response[0].audioContent, 'binary')
}).then(() => {
	console.log('writing text...')
	return writeFile(`${__dirname}/gentts/${name}/temp.txt`, argv._[0].split(' ').join('\n'), 'UTF-8')
}).then(() => {
	console.log('running aligner...')
	return exec(`python3 -m aeneas.tools.execute_task ${__dirname}/gentts/${name}/temp.mp3 ${__dirname}/gentts/${name}/temp.txt "task_language=eng|os_task_file_format=json|is_text_type=plain" ${__dirname}/gentts/${name}/out.json`)
}).then(() => {
	console.log('done!')
})
