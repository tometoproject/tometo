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

const name = argv.n

mkdir(`${__dirname}/gentts/${name}`).then(() => {
	console.log('synthesizing speech...')
	return synthesize()
}).then(() => {
	console.log('writing text...')
	return writeFile(`${__dirname}/gentts/${name}/temp.txt`, argv._[0].split(' ').join('\n'), 'UTF-8')
}).then(() => {
	console.log('running aligner...')
	return exec(`python3 -m aeneas.tools.execute_task ${__dirname}/gentts/${name}/temp.ogg ${__dirname}/gentts/${name}/temp.txt "task_language=eng|os_task_file_format=json|is_text_type=plain" ${__dirname}/gentts/${name}/out.json`)
}).then(() => {
	console.log('done!')
})

async function synthesize () {
	if (config.otemot.speech === 'google') {
		const client = new TextToSpeechClient({
			keyFilename: config.otemot.google.credentials_path
		})
		const rq = {
			input: { text: argv._[0] },
			voice: { languageCode: 'en-US', name: 'en-US-Standard-B' },
			audioConfig: {
				audioEncoding: 'OGG_OPUS',
				pitch: argv.p || 0,
				speakingRate: argv.s || 1.0
			}
		}
		let res = await client.synthesizeSpeech(rq)
		await writeFile(`${__dirname}/gentts/${name}/temp.ogg`, res[0].audioContent, 'binary')
	} else {
		let scalePitch = Math.round(((argv.p + 20) / 40 * 99))
		let scaleSpeed = Math.round(((argv.s - 0.25) / 3.75 * 370) + 80)
		await exec(`espeak -p ${scalePitch} -s ${scaleSpeed} -w ${__dirname}/gentts/${name}/temp.wav "${argv._[0]}"`)
		await exec(`ffmpeg -i ${__dirname}/gentts/${name}/temp.wav -c:a libopus -b:a 96K ${__dirname}/gentts/${name}/temp.ogg`)
	}
	return true
}
