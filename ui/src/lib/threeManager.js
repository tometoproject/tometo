import * as THREE from 'three'
import { GLTFLoader } from 'three/examples/jsm/loaders/GLTFLoader'
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls'

class ThreeManager {
  constructor () {
    this.scene = null
    this.camera = null
    this.renderer = null
    this.loader = null
    this.controls = null
    this.canvas = null
    this.model = null
    this.canvasContext = null
    this.width = 0
    this.height = 0
  }

  initWithDefaultOptions (id) {
    this.width = document.getElementById(id).offsetWidth
    this.height = document.getElementById(id).offsetHeight
    this.scene = new THREE.Scene()
    this.scene.add(new THREE.AmbientLight(0x666666))
    this.scene.add(new THREE.DirectionalLight(0xFFFFFF, 0.5))
    this.scene.background = new THREE.Color('white')
    this.camera = new THREE.PerspectiveCamera(70, this.width / this.height, 0.01, 100)
    this.renderer = new THREE.WebGLRenderer({
      canvas: document.getElementById(id),
      antialias: true
    })
    this.renderer.setSize(this.width, this.height)
    this.renderer.setClearColor(0xDDDDDD, 1)
    this.controls = new OrbitControls(this.camera, this.renderer.domElement)
  }

  initForGLTF () {
    this.loader = new GLTFLoader()
    this.canvas = document.createElement('canvas')
    this.canvasContext = this.canvas.getContext('2d')
  }

  async loadModel (model, layer) {
    this.loader.load(model, gltf => {
      // Center the camera on the loaded model
      const box = new THREE.Box3()
      let boxVec = new THREE.Vector3()
      box.setFromObject(gltf.scene)
      box.getCenter(boxVec)
      this.camera.position.copy(boxVec)
      this.camera.position.add(new THREE.Vector3(1, 2, 2))
      this.model = gltf.scene.children[layer]
      this.scene.add(this.model)
      this.model.material.map = new THREE.CanvasTexture(this.canvas)
      return gltf
    }, undefined, error => {
      console.error(error)
    })
  }

  draw (src, dx, dy, dw, dh) {
    this.canvasContext.drawImage(src, dx, dy, dw, dh)
    if (this.model) {
      this.model.material.map.needsUpdate = true
    }
  }

  animate () {
    this.controls.update()
    this.renderer.render(this.scene, this.camera)
  }
}

export default ThreeManager
