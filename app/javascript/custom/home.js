document.addEventListener("turbo:load", () => {
  const isMobile = /iPhone|Android.+Mobile|Windows Phone|iPod/i.test(navigator.userAgent);
  if (isMobile) return;
  if (window._threeInitialized) return;
  window._threeInitialized = true;
  var mixer;
  const clock = new THREE.Clock();

  const scene = new THREE.Scene();
  let camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1000);
  const canvas   = document.getElementById('three-canvas');
  const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
  renderer.setSize(canvas.clientWidth, canvas.clientHeight);
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

  loader.load('/home.glb', function (gltf) {
  const model = gltf.scene;
  model.scale.set(1, 1, 1);
  scene.add(model);

  mixer = new THREE.AnimationMixer(model);
  window.mixer = mixer;
  window.bookAnimationClips = gltf.animations;
  window.doorAnimationClips = gltf.animations;

  const bookBtn = document.getElementById("open-book");
if (bookBtn) {
  bookBtn.addEventListener("click", (e) => {
    e.preventDefault();

    const animationNames = [
      "BookOpen", "Action.004", "Action.005", "Action.006", "Action.007", "Action.008",
      "Action.009", "Action.010", "Action.011", "Action.012", "Action.013", "Action.014",
      "Action.015", "Action.016", "Action.017", "Action.018", "Action.001", "Action.002",
      "Action"
    ];

    if (window.mixer && window.doorAnimationClips) {
      let maxDuration = 0;

      animationNames.forEach(name => {
        const clip = window.bookAnimationClips.find(c => c.name === name);
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
        window.location.href = bookBtn.dataset.roomPath;
      }, maxDuration * 1000);
    } else {
      window.location.href = bookBtn.dataset.roomPath;
    }
  });
}

  if (gltf.cameras && gltf.cameras.length > 0) {
    const cameraName = "1カメ";
    const foundCameraObject = model.getObjectByName(cameraName);
    const foundCamera = gltf.cameras.find(cam => cam.name === cameraName);
    if (foundCamera) {
      customCamera = foundCamera;
      customCamera.up.set(0, 1, 0);
      customCamera.rotation.y += Math.PI;
      customCamera.position.z += 1;
    }
  }

 const spotBtn = document.getElementById("open-door");
if (spotBtn) {
  spotBtn.addEventListener("click", (e) => {
    e.preventDefault();

    const doorNames = [
      "part_key_window.004Action", "key_window_hook.003Action",
      "1カメAction"
    ];

    if (customCamera) {
        customCamera.aspect = camera.aspect;
        customCamera.updateProjectionMatrix();
        controls.object = customCamera; // OrbitControlsを更新
        camera = customCamera;
        scene.add(camera);
      }

    if (window.mixer && window.bookAnimationClips) {
      let maxDuration = 0;

      doorNames.forEach(name => {
        const clip = window.doorAnimationClips.find(c => c.name === name);
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
        window.location.href = spotBtn.dataset.roomPath;
      }, maxDuration * 1000);
    } else {
      window.location.href = spotBtn.dataset.roomPath;
    }
  });
}
}, undefined, function (error) {
});

  camera.position.z = 5;

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
    const width  = canvas.clientWidth;
    const height = canvas.clientHeight;
    renderer.setSize(width, height);
    camera.aspect = width / height;
    camera.updateProjectionMatrix();
  });
});

