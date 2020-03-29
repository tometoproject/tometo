<script>
  import { createEventDispatcher } from 'svelte'
  export let name
  export let pitch = 10
  export let speed = 1.0
  export let language = 'en'
  export let gender

  const dispatch = createEventDispatcher()
  const pics = {
    pic1: '',
    pic2: ''
  }
  let interval = null
  let cycle = true
  let imagePreview = ''

  // This function is a bit different:
  // 1. It's a higher-order function, meaning it returns another function specific
  //    to the `num` argument passed into it. That inner function can accept an event.
  // 2. It dispatches a custom event so that the parent component can listen to picture
  //    file changes and update its own variables if needed.
  const updatePic = num => evt => {
    if (evt.target.files.length > 0) {
      pics[`pic${String(num)}`] = evt.target.files[0]
      dispatch(`updatePic${String(num)}`, evt.target.files[0])
    }
  }

  $: if (pics.pic1 instanceof File && pics.pic2 instanceof File) {
    clearInterval(interval)
    interval = setInterval(picCycle, 500)
  } else {
    clearInterval(interval)
  }

  function picCycle () {
    const reader = new FileReader()
    reader.addEventListener('load', () => {
      imagePreview = reader.result
    })

    reader.readAsDataURL(cycle ? pics.pic1 : pics.pic2)
    cycle = !cycle
  }
</script>

<fieldset class="form-group">
  <label class="form-label label-lg">Name</label>
  <input
    class="form-input input-lg"
    bind:value={name}
    type="text"
  />
</fieldset>

<fieldset class="form-group">
  <label class="form-label label-lg">Pitch <i>Number from -20 to 20</i></label>
  <input
    class="form-input input-lg"
    bind:value={pitch}
    type="number"
    max=20
    min=-20
  />
</fieldset>

<fieldset class="form-group">
  <label class="form-label label-lg">Speed <i>Number from (0.25 to 4.0)</i></label>
  <input
    class="form-input input-lg"
    bind:value={speed}
    type="number"
    min=0.25
    max=4.0
    step=0.1
  />
</fieldset>

<fieldset>
  <label>Language</label>
  <select bind:value={language}>
    <option value="ar">
      Arabic
    </option>
    <option value="nl">
      Dutch
    </option>
    <option value="en">
      English
    </option>
    <option value="fr">
      French
    </option>
    <option value="de">
      German
    </option>
    <option value="hi">
      Hindi
    </option>
    <option value="id">
      Indonesian
    </option>
    <option value="it">
      Italian
    </option>
    <option value="ja">
      Japanese
    </option>
    <option value="ko">
      Korean
    </option>
    <option value="zh">
      Mandarin Chinese
    </option>
    <option value="nb">
      Norwegian
    </option>
    <option value="pl">
      Polish
    </option>
    <option value="pt">
      Portuguese
    </option>
    <option value="ru">
      Russian
    </option>
    <option value="tr">
      Turkish
    </option>
    <option value="vi">
      Vietnamese
    </option>
  </select>
</fieldset>

<fieldset>
  <label>Voice Sound</label>
  <select bind:value={gender}>
    <option value="FEMALE">
      Female
    </option>
    <option value="MALE">
      Male
    </option>
  </select>
</fieldset>

<div class="grid grid--gap grid--2-50">
  <div>
    <fieldset>
      <label>Closed Mouth image</label>
      <label>
        <input
          type="file"
          accept="image/png, image/jpeg"
          on:change={updatePic(1)}
        />
      </label>
    </fieldset>

    <fieldset>
      <label>Open Mouth image</label>
      <label>
        <input
          type="file"
          accept="image/png, image/jpeg"
          on:change={updatePic(2)}
        />
      </label>
    </fieldset>
  </div>

  {#if interval}
    <img
      src={imagePreview}
      alt="Preview of your generated Avatar"
      height=150
    />
  {/if}
</div>
