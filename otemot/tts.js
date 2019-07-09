const { TextToSpeechClient } = require('@google-cloud/text-to-speech')
const mkdir = require('make-dir')
const del = require('del')

const fs = require('fs')
const util = require('util')
const childProcess = require('child_process')
const writeFile = util.promisify(fs.writeFile)
const rename = util.promisify(fs.rename)
const exec = util.promisify(childProcess.exec)
const argv = require('minimist')(process.argv.slice(2))
require('dotenv').config()

const client = new TextToSpeechClient()
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

mkdir(`${__dirname}/${name}`).then(() => {
  console.log('synthesizing speech...')
  return client.synthesizeSpeech(rq)
}).then(response => {
  console.log('writing audio...')
  return writeFile(`${__dirname}/${name}/temp.mp3`, response[0].audioContent, 'binary')
}).then(() => {
  console.log('writing text...')
  return writeFile(`${__dirname}/${name}/temp.txt`, argv._[0].split(' ').join('\n'), 'UTF-8')
}).then(() => {
  console.log('running aligner...')
  return exec(`python3 -m aeneas.tools.execute_task ${__dirname}/${name}/temp.mp3 ${__dirname}/${name}/temp.txt "task_language=eng|os_task_file_format=json|is_text_type=plain" ${__dirname}/${name}/out.json`)
}).then(() => {
  console.log('storing...')
  switch (process.env.STORAGE) {
    case 'local':
      return Promise.all([
        rename(`${__dirname}/${name}/out.json`, `${process.cwd()}/storage/${name}.json`),
        rename(`${__dirname}/${name}/temp.mp3`, `${process.cwd()}/storage/${name}.mp3`)
      ])
  }
}).then(() => {
  console.log('cleaning up...')
  return Promise.all([
    del(`${__dirname}/${name}`)
  ])
}).then(() => {
  console.log('done!')
})
