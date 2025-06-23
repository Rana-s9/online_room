(() => {
  // app/javascript/custom/door2.js
  var mixer;
  var clock = new THREE.Clock();
  var scene = new THREE.Scene();
  var camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1e3);
  var canvas = document.getElementById("three-canvas");
  var renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setPixelRatio(window.devicePixelRatio);
  scene.background = new THREE.Color("#F8F8F0");
  var light = new THREE.DirectionalLight(16777215, 1);
  light.position.set(10, 10, 10).normalize();
  scene.add(light);
  var ambientLight = new THREE.AmbientLight(4210752, 1.5);
  scene.add(ambientLight);
  var dracoLoader = new THREE.DRACOLoader();
  dracoLoader.setDecoderPath("https://www.gstatic.com/draco/v1/decoders/");
  var loader = new THREE.GLTFLoader();
  loader.setDRACOLoader(dracoLoader);
  loader.load("/door2.glb", function(gltf) {
    const model = gltf.scene;
    model.scale.set(0.8, 0.8, 0.8);
    const box = new THREE.Box3().setFromObject(model);
    const center = box.getCenter(new THREE.Vector3());
    model.position.sub(center);
    scene.add(model);
    mixer = new THREE.AnimationMixer(model);
    window.mixer = mixer;
    window.doorAnimationClips = gltf.animations;
    const doorBtn = document.getElementById("blue-door");
    if (doorBtn) {
      doorBtn.addEventListener("click", (e) => {
        const animationNames = [
          "CubeAction.001"
        ];
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
              if (clip.duration > maxDuration) {
                maxDuration = clip.duration;
              }
            }
          });
          setTimeout(() => {
            doorBtn.closest("form").submit();
          }, maxDuration * 1e3);
        } else {
          doorBtn.closest("form").submit();
        }
      });
    }
  }, void 0, function(error) {
  });
  camera.position.set(10, -5, 0);
  camera.lookAt(0, 2, 0);
  var controls = new THREE.OrbitControls(camera, renderer.domElement);
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
  window.addEventListener("resize", () => {
    const width = window.innerWidth;
    const height = window.innerHeight;
    renderer.setSize(width, height);
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
  });
})();
//# sourceMappingURL=assets/door2.js.map
