<template>
    <form v-on:keyup-enter="submitForm">
        <h1>Create an Avatar</h1>

        <fieldset>
            <label>Name</label>
            <input type="text" v-model="name" />
        </fieldset>

        <fieldset>
            <label>Pitch <i>(Number from 0 to 30)</i></label>
            <input type="number" v-model="pitch" value="10" max="30" min="0" />
        </fieldset>

        <fieldset>
            <label>Speed <i>(Number from 0.1 to 2.0)</i></label>
            <input type="number" v-model="speed" value="1.0" step="0.1" max="2" min="0.1" />
        </fieldset>

        <div class="columns">
            <div class="column">
                <fieldset>
                    <label>Language</label>
                    <div>
                        <select v-model="language">
                            <option value="en">English</option>
                        </select>
                    </div>
                </fieldset>
            </div>
            <div class="column">
                <fieldset>
                    <label>Voice Sound</label>
                    <div>
                        <select v-model="gender">
                            <option value="f">Female</option>
                            <option value="m">Male</option>
                        </select>
                    </div>
                </fieldset>
            </div>
        </div>

        <div class="grid grid-2-50">
            <div>
                <fieldset>
                    <label>Closed Mouth image</label>
                    <div>
                        <label>
                            <input type="file" accept="image/png, image/jpeg" v-on:change="updatePic(1, $event)" />
                        </label>
                    </div>
                </fieldset>

                <fieldset>
                    <label>Open Mouth image</label>
                    <div>
                        <label>
                            <input type="file" accept="image/png, image/jpeg" v-on:change="updatePic(2, $event)" />
                        </label>
                    </div>
                </fieldset>
            </div>

            <div v-if="bothFilesAreEntered">
                <img :src="imagePreview" height=150 />
            </div>
        </div>

        <button @click="submitForm" :disabled="loading">Submit</button>
    </form>
</template>

<script>
import router from '../router'

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
            pic2: '',
            interval: null,
            cycle: true,
            imagePreview: '',
        }
    },
    computed: {
        loading () {
            return this.$store.state.loading
        },
        bothFilesAreEntered () {
            if (this.$data.pic1 instanceof File && this.$data.pic2 instanceof File) {
                this.$data.interval = setInterval(this.picCycle, 500)
                return true
            } else {
                clearInterval(this.$data.interval)
            }
        }
    },
    methods: {
        updatePic (num, evt) {
            if (evt.target.files.length > 0) {
                this.$data[`pic${String(num)}`] = evt.target.files[0]
            }
        },
        submitForm (e) {
            e.preventDefault()
            let { name, pitch, speed, language, gender, pic1, pic2 } = this
            this.$store.dispatch('createAvatar', { name, pitch, speed, language, gender, pic1, pic2 })
        },
        fileName (num) {
            return this.$data[`pic${String(num)}`].name
        },
        picCycle () {
            let reader = new FileReader()
            reader.addEventListener('load', () => {
                this.$data.imagePreview = reader.result
            })
            if (this.$data.cycle) {
                reader.readAsDataURL(this.$data.pic1)
            } else {
                reader.readAsDataURL(this.$data.pic2)
            }
            this.$data.cycle = !this.$data.cycle
        }
    },
    beforeMount () {
        if (!this.$store.state.username)
            router.back()
    },
}
</script>
