<script>
  import { onMount, onDestroy } from 'svelte'
  import ThreeManager from '../threeManager'

  export let timestamps
  export let pic1
  export let pic2
  export let audioUrl
  export let name
  export let id
  export let isComment

  const audio = {
    ctx: null,
    src: null,
    analyzer: null,
    media: null,
    dest: null,
    isLoud: null,
    playing: false
  }
  const text = {
    words: [],
    unplayed: [],
    played: [],
    interval: null,
    index: 0
  }
  const three = new ThreeManager()
  const loaded = {
    audio: false,
    json: false
  }

  $: isLoaded = loaded.audio && loaded.json
  $: answerKey = `avatar${id}`

  function initAudio () {
    audio.ctx = new window.AudioContext()
    audio.src = audio.ctx.createMediaElementSource(audio.media)
    audio.analyzer = audio.ctx.createAnalyser()
    audio.analyzer.fftSize = 512
    audio.analyzer.smoothingTimeConstant = 0.9
    audio.playing = false
    audio.src.connect(audio.analyzer)
    audio.analyzer.connect(audio.ctx.destination)
    audio.ctx.suspend()
  }

  function togglePlaying () {
    if (audio.media.paused && isLoaded) {
      text.interval = setInterval(() => tick(), 100)
      audio.ctx.resume()
      audio.media.play()
      audio.playing = true
    } else if (!audio.media.paused && isLoaded) {
      audio.media.pause()
      audio.ctx.suspend()
      clearInterval(text.interval)
      audio.playing = false
    }
  }

  function tick () {
    if (isLoaded && text.index < text.words.length) {
      const cur = text.words[text.index]
      const time = audio.ctx.currentTime
      audio.isLoud = getVolume() > 1
      if (time > Number(cur.begin)) {
        text.index += 1
        const words = text.unplayed.shift()
        text.played.push(words)
      }
    } else {
      audio.isLoud = false
    }
    updateImage()
  }

  function updateImage () {
    if (audio.isLoud) {
      three.draw('mouth', document.getElementById(`${id}pic2`), 0, 0, 256, 256)
    } else {
      three.draw('mouth', document.getElementById(`${id}pic1`), 0, 0, 256, 256)
    }
  }

  function getVolume () {
    const array = new Uint8Array(audio.analyzer.fftSize)
    audio.analyzer.getByteTimeDomainData(array)

    let average = 0
    for (let i = 0; i < array.length; i++) {
      const a = Math.abs(array[i] - 128)
      average += a
    }

    average /= array.length
    return average
  }

  function animate () {
    requestAnimationFrame(animate)
    three.animate()
  }

  onMount(() => {
    fetch(timestamps)
      .then(res => res.json())
      .then(res => {
        loaded.json = true
        // Initialize the words array by shoving everything into unplayed
        text.words = res.fragments
        text.unplayed = text.words.map(w => w.lines).flat()
        audio.media = new Audio(audioUrl)
        audio.media.crossOrigin = 'anonymous'
        initAudio()
        // Prepare for loading our model and initialize more 3D stuff
        three.initWithDefaultOptions(answerKey)
        three.initForGLTF()

        // When the audio is finished loading (which always happens after timestamp loading),
        // we set the boolean flag and properly load the model, and start animating.
        audio.media.addEventListener('canplaythrough', () => {
          loaded.audio = true
          three.loadModel(`${process.env.T_BACKEND_URL}/static/cube.glb`, 0).then(gltf => {
            three.draw('eyeL', document.getElementById(`eyeL`), 0, 0, 256, 256)
            three.draw('eyeR', document.getElementById(`eyeR`), 0, 0, 256, 256)
            three.draw('mouth', document.getElementById(`${id}pic1`), 0, 0, 256, 256)
            animate()
          })
        })

        audio.media.addEventListener('ended', () => {
          // Reset the audio timestamp and other related things
          initAudio()
          text.unplayed = text.played
          text.played = []
          text.index = 0
          clearInterval(text.interval)
        })
      })
  })

  onDestroy(() => {
    clearInterval(text.interval)
    three.destroy()
  })
</script>

<div class="container columns">
  <canvas class="column col-6" id={`avatar${id}`} style="min-height: 100%;">
    <img id={`${id}pic1`} style="display: none;" alt="Avatar state 1" crossOrigin src={pic1} />
    <img id={`${id}pic2`} style="display: none;" alt="Avatar state 2" crossOrigin src={pic2} />
    <img id="eyeL" style="display: none;" crossOrigin src="http://localhost:4001/static/av1-eyeL.png" />
    <img id="eyeR" style="display: none;" crossOrigin src="http://localhost:4001/static/av1-eyeR.png" />
  </canvas>
  <div class="column col-6 card card-speech-bubble">
    <div class="card-header">
      <span class="btn btn-action btn-primary" on:click={togglePlaying}>
        {#if audio.playing && isLoaded}❚❚{:else if !audio.playing && isLoaded}▶{:else}侢{/if}
      </span>
      <span class="text-blue">{name}</span> {isComment ? 'comments' : 'answers'}:
    </div>
    <div class="card-body mt-2">
      <h1>
        <span class="v-mid text-light-blue">{text.played.join(' ')}</span>
        <span class="v-mid">{text.unplayed.join(' ')}</span>
      </h1>
    </div>
    <div class="card-footer">
      <a class="btn btn-sm" href={audioUrl}>🔽 Download audio</a>
    </div>
  </div>
</div>
