let mixer;
const clock = new THREE.Clock();

const scene = new THREE.Scene();
const camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
const canvas   = document.getElementById('three-canvas');
const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
renderer.setSize(window.innerWidth, window.innerHeight);
renderer.setPixelRatio(window.devicePixelRatio);
scene.background = new THREE.Color('#F8F8F0');

const light = new THREE.DirectionalLight(0xffffff, 1);
light.position.set(10, 10, 10).normalize();
scene.add(light);

const ambientLight = new THREE.AmbientLight(0x404040, 1.5);
scene.add(ambientLight);

let dracoLoader = new THREE.DRACOLoader();
dracoLoader.setDecoderPath('https://www.gstatic.com/draco/v1/decoders/');

let loader = new THREE.GLTFLoader();
loader.setDRACOLoader(dracoLoader);

loader.load('https://pub-66ad90e703114a8a903b4c24ca19293d.r2.dev/door.glb', function (gltf) {
const model = gltf.scene;
model.scale.set(0.8, 0.8, 0.8);

const box = new THREE.Box3().setFromObject(model);
const center = box.getCenter(new THREE.Vector3());

model.position.sub(center);
scene.add(model);

mixer = new THREE.AnimationMixer(model);
window.mixer = mixer;
window.doorAnimationClips = gltf.animations;

const doorButtons = document.querySelectorAll(".door-button");
doorButtons.forEach((doorBtn) => {
  doorBtn.addEventListener("click", (e) => {
    e.preventDefault();

    const animationNames = ["CubeAction.001"];

    if (window.mixer && window.doorAnimationClips) {
      let maxDuration = 0;

      animationNames.forEach((name) => {
        const clip = window.doorAnimationClips.find((c) => c.name === name);
        if (clip) {
          const action = window.mixer.clipAction(clip);
          action.reset();
          action.setLoop(THREE.LoopOnce, 1);
          action.clampWhenFinished = true;
          action.play();
          maxDuration = Math.max(maxDuration, clip.duration);
        }
      });

      setTimeout(() => {
        window.location.href = doorBtn.href;
      }, maxDuration * 1000);
    } else {
      window.location.href = doorBtn.href;
    }
  });
});
});

camera.position.set(10, -5, 0);
camera.lookAt(0, 2, 0);

const controls = new THREE.OrbitControls(camera, renderer.domElement);
controls.enableDamping = true;
controls.dampingFactor = 0.05;
controls.screenSpacePanning = false;
controls.maxPolarAngle = Math.PI / 2;

function animate() {
requestAnimationFrame(animate);
controls.update();

const delta = clock.getDelta();
if (mixer) mixer.update(delta);

renderer.render(scene, camera);
}
animate();

window.addEventListener('resize', () => {
const width  = window.innerWidth;
const height = window.innerHeight;
renderer.setSize(width, height);
camera.aspect = width / height;
camera.updateProjectionMatrix();
});