<template>
  <span>
    <fieldset>
      <label>Name</label>
      <input
        v-model="name"
        type="text"
        @input="$emit('update:aName', $event.target.value)"
      >
    </fieldset>

    <fieldset>
      <label>Pitch <i>(Number from -20 to 20)</i></label>
      <input
        v-model="pitch"
        type="number"
        value="10"
        max="20"
        min="-20"
        @input="$emit('update:aPitch', $event.target.value)"
      >
    </fieldset>

    <fieldset>
      <label>Speed <i>(Number from 0.25 to 4.0)</i></label>
      <input
        v-model="speed"
        type="number"
        value="1.0"
        step="0.1"
        max="4.0"
        min="0.25"
        @input="$emit('update:aSpeed', $event.target.value)"
      >
    </fieldset>

    <fieldset>
      <label>Language</label>
      <select
        v-model="language"
        @input="$emit('update:aLanguage', $event.target.value)"
      >
        <option value="ar">
          Arabic
        </option>
        <option value="nl">
          Dutch
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
      <select
        v-model="gender"
        @input="$emit('update:aGender', $event.target.value)"
      >
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
              @change="updatePic(1, $event)"
            >
          </label>
        </fieldset>

        <fieldset>
          <label>Open Mouth image</label>
          <label>
            <input
              type="file"
              accept="image/png, image/jpeg"
              @change="updatePic(2, $event)"
            >
          </label>
        </fieldset>
      </div>

      <div v-if="bothFilesAreEntered">
        <img
          :src="imagePreview"
          height="150"
        >
      </div>
    </div>
  </span>
</template>

<script>
export default {
  name: 'AvatarDetails',
  props: {
    aName: {
      type: String,
      default: ''
    },
    aPitch: {
      type: Number,
      default: 10
    },
    aSpeed: {
      type: Number,
      default: 10
    },
    aLanguage: {
      type: String,
      default: 'en'
    },
    aGender: {
      type: String,
      default: 'FEMALE'
    }
  },
  data () {
    return {
      name: this.aName,
      pitch: this.aPitch,
      speed: this.aSpeed,
      language: this.aLanguage,
      gender: this.aGender,
      pic1: '',
      pic2: '',
      interval: null,
      cycle: true,
      imagePreview: ''
    }
  },
  watch: {
    aName (n, o) { this.name = n },
    aPitch (n, o) { this.pitch = n },
    aSpeed (n, o) { this.speed = n },
    aLanguage (n, o) { this.language = n },
    aGender (n, o) { this.gender = n }
  },
  methods: {
    updatePic (num, evt) {
      if (evt.target.files.length > 0) {
        this[`pic${String(num)}`] = evt.target.files[0]
        this.$emit(`update:pic${String(num)}`, evt.target.files[0])
      }
    },
    bothFilesAreEntered () {
      if (this.pic1 instanceof File && this.pic2 instanceof File) {
        this.interval = setInterval(this.picCycle, 500)
        return true
      } else {
        clearInterval(this.interval)
        return false
      }
    },
    picCycle () {
      let reader = new FileReader()
      reader.addEventListener('load', () => {
        this.imagePreview = reader.result
      })
      if (this.cycle) {
        reader.readAsDataURL(this.pic1)
      } else {
        reader.readAsDataURL(this.pic2)
      }
      this.cycle = !this.cycle
    }
  }
}
</script>
