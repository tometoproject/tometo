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
    this.model = null
    this.canvas = {
      eyeL: null,
      eyeR: null,
      mouth: null
    }
    this.subModels = {
      eyeL: null,
      eyeR: null,
      mouth: null
    }
    this.canvasContext = {
      eyeL: null,
      eyeR: null,
      mouth: null
    }
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
    for (const name in this.canvas) {
      this.canvas[name] = document.createElement('canvas')
      this.canvas[name].height = 256
      this.canvas[name].width = 256
      this.canvasContext[name] = this.canvas[name].getContext('2d')
    }
  }

  async loadModel (model, layer) {
    this.loader.load(model, gltf => {
      // Center the camera on the loaded model
      const box = new THREE.Box3()
      const boxVec = new THREE.Vector3()
      box.setFromObject(gltf.scene)
      box.getCenter(boxVec)
      this.camera.position.copy(boxVec)
      this.camera.position.add(new THREE.Vector3(3, 1, 1.4))
      this.model = gltf.scene.children[layer]
      this.scene.add(this.model)
      for (const name in this.subModels) {
        const canvasSide = new THREE.MeshBasicMaterial()
        canvasSide.map = new THREE.CanvasTexture(this.canvas[name])
        const mats = [
          new THREE.MeshBasicMaterial({ transparent: true }),
          new THREE.MeshBasicMaterial({ transparent: true }),
          new THREE.MeshBasicMaterial({ transparent: true }),
          new THREE.MeshBasicMaterial({ transparent: true }),
          canvasSide,
          new THREE.MeshBasicMaterial({ transparent: true })
        ]
        this.subModels[name] = new THREE.Mesh(new THREE.BoxGeometry(1, 1, 0.1), mats)
      }
      this.subModels.eyeL.translateX(0.96)
      this.subModels.eyeR.translateX(0.96)
      this.subModels.mouth.translateX(0.96)
      this.subModels.eyeL.translateY(0.450)
      this.subModels.eyeR.translateY(0.450)
      this.subModels.mouth.translateY(-0.400)
      this.subModels.eyeL.translateZ(0.450)
      this.subModels.eyeR.translateZ(-0.450)
      this.subModels.eyeL.scale.set(0.6, 0.6, 1)
      this.subModels.eyeR.scale.set(0.6, 0.6, 1)
      this.subModels.mouth.scale.set(1, 0.8, 1)
      this.subModels.eyeL.rotateY(1.570)
      this.subModels.eyeR.rotateY(1.570)
      this.subModels.mouth.rotateY(1.570)
      this.scene.add(this.subModels.eyeL)
      this.scene.add(this.subModels.eyeR)
      this.scene.add(this.subModels.mouth)
      return gltf
    }, undefined, error => {
      console.error(error)
    })
  }

  draw (name, src, dx, dy, dw, dh) {
    this.canvasContext[name].drawImage(src, dx, dy, dw, dh)
    if (this.subModels[name]) {
      this.subModels[name].material[4].map.needsUpdate = true
    }
  }

  animate () {
    this.controls.update()
    this.renderer.render(this.scene, this.camera)
  }

  destroy () {
    this.controls.dispose()
    this.scene.dispose()
    this.renderer.forceContextLoss()
    this.renderer.dispose()
  }
}

export default ThreeManager
