<script>
  export let timestamps
  export let pic1
  export let pic2
  export let audioUrl
  export let name
  export let id
  import { onMount, onDestroy } from 'svelte'
  import ThreeManager from '../threeManager'

  let audio = {
    ctx: null,
    src: null,
    analyzer: null,
    media: null,
    dest: null,
    isLoud: null,
    playing: false
  }
  let text = {
    words: [],
    unplayed: [],
    played: [],
    interval: null,
    index: 0
  }
  let three = new ThreeManager()
  let loaded = {
    audio: false,
    json: false
  }

  $: isLoaded = loaded.audio && loaded.json
  $: statusKey = `avatar${id}`

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
      three.draw(document.getElementById(`${id}pic2`), 0, 0, 256, 256)
    } else {
      three.draw(document.getElementById(`${id}pic1`), 0, 0, 256, 256)
    }
  }

  function getVolume () {
    let array = new Uint8Array(audio.analyzer.fftSize)
    audio.analyzer.getByteTimeDomainData(array)

    let average = 0
    for (let i = 0; i < array.length; i++) {
      let a = Math.abs(array[i] - 128)
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
        three.initWithDefaultOptions(statusKey)
        three.initForGLTF()

        // When the audio is finished loading (which always happens after timestamp loading),
        // we set the boolean flag and properly load the model, and start animating.
        audio.media.addEventListener('canplaythrough', () => {
          loaded.audio = true
          three.loadModel(`${process.env.T_BACKEND_URL}/static/cube.glb`, 0).then(gltf => {
            three.draw(document.getElementById(`${id}pic1`), 0, 0, 256, 256)
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
  })
</script>

<div class="grid grid--gap grid--2-50">
  <canvas id={`avatar${id}`} style="width: 100%; min-height: 100%;">
    <img id={`${id}pic1`} style="display: none;" crossOrigin src={pic1} />
    <img id={`${id}pic2`} style="display: none;" crossOrigin src={pic2} />
  </canvas>
  <div>
    <span class="button button--vmid button--fullwidth" on:click={togglePlaying}>
      {#if audio.playing && isLoaded}❚❚{:else if !audio.playing && isLoaded}▶{:else}侢{/if}
    </span>
    <p><span class="color--blue">{name}</span> says:</p>
    <h1 class="h1--uncentered h1--nomargin">
      <span class="text--vmid text--lhdefault color--blue">{text.played.join(' ')}</span>
      <span class="text--vmid text--lhdefault">{text.unplayed.join(' ')}</span>
    </h1>
    <p class="text--small">
      <a href={audioUrl}>🔽 Download audio</a>
    </p>
  </div>
</div>
