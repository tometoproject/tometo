<template>
  <section v-on:keyup-enter="submitForm">
    <h1 class="title is-1">Create an Avatar</h1>

    <fieldset class="field">
      <label class="label">Name</label>
      <input class="input is-large" type="text" v-model="name" />
    </fieldset>

    <fieldset class="field">
      <label class="label">Pitch <i>(Number from 0 to 30)</i></label>
      <input class="input is-large" type="number" v-model="pitch" value="10" max="30" min="0" />
    </fieldset>

    <fieldset class="field">
      <label class="label">Speed <i>(Number from 0.1 to 2.0)</i></label>
      <input class="input is-large" type="number" v-model="speed" value="1.0" step="0.1" max="2" min="0.1" />
    </fieldset>

    <div class="columns">
      <div class="column">
        <fieldset class="field">
          <label class="label">Language</label>
          <div class="select">
            <select v-model="language">
              <option value="en">English</option>
            </select>
          </div>
        </fieldset>
      </div>
      <div class="column">
        <fieldset class="field">
          <label class="label">Voice Sound</label>
          <div class="select">
            <select v-model="gender">
              <option value="f">Female</option>
              <option value="m">Male</option>
            </select>
          </div>
        </fieldset>
      </div>
    </div>

    <fieldset class="field">
      <label class="label">Closed Mouth image</label>
      <div class="file">
        <label class="file-label">
          <input class="file-input" type="file" accept="image/png, image/jpeg" v-on:change="updatePic(1, $event)" />
          <span class="file-cta">
            <span class="file-label">Choose a file...</span>
          </span>
          <span class="file-name" v-if="fileExists(1)">
            {{ fileName(1) }}
          </span>
        </label>
      </div>
    </fieldset>

    <fieldset class="field">
      <label class="label">Open Mouth image</label>
      <div class="file">
        <label class="file-label">
          <input class="file-input" type="file" accept="image/png, image/jpeg" v-on:change="updatePic(2, $event)" />
          <span class="file-cta">
            <span class="file-label">Choose a file...</span>
          </span>
          <span class="file-name" v-if="fileExists(2)">
            {{ fileName(2) }}
          </span>
        </label>
      </div>
    </fieldset>

    <button class="button is-info" @click="submitForm" :disabled="loading">Submit</button>
  </section>
</template>

<script>
 export default {
   name: 'CreateAvatar',
   data () {
     return {
       name: '',
       pitch: 10,
       speed: 1.0,
       language: 'en',
       gender: 'f',
       pic1: '',
       pic2: ''
     }
   },
   computed: {
     loading () {
       return this.$store.state.loading
     }
   },
   methods: {
     updatePic (num, evt) {
       if (evt.target.files.length > 0) {
         this.$data[`pic${String(num)}`] = evt.target.files[0]
       }
     },
     fileExists (num) {
       return this.$data[`pic${String(num)}`]
     },
     submitForm () {
       let { name, pitch, speed, language, gender, pic1, pic2 } = this
       this.$store.dispatch('createAvatar', { name, pitch, speed, language, gender, pic1, pic2 })
     },
     fileName (num) {
       return this.$data[`pic${String(num)}`].name
     }
   }
 }
</script>
