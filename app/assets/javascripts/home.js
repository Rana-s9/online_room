(() => {
  // app/javascript/custom/home.js
  document.addEventListener("turbo:load", () => {
    if (window._threeInitialized) return;
    window._threeInitialized = true;
    var mixer;
    const clock = new THREE.Clock();
    const scene = new THREE.Scene();
    let camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 0.1, 1e3);
    let customCamera1;
    const canvas = document.getElementById("three-canvas");
    const renderer = new THREE.WebGLRenderer({ canvas, antialias: true });
    renderer.setSize(canvas.clientWidth, canvas.clientHeight);
    scene.background = new THREE.Color("#F8F8F0");
    const light = new THREE.DirectionalLight(16777215, 1);
    light.position.set(10, 10, 10).normalize();
    scene.add(light);
    const ambientLight = new THREE.AmbientLight(4210752, 1.5);
    scene.add(ambientLight);
    let dracoLoader = new THREE.DRACOLoader();
    dracoLoader.setDecoderPath("https://www.gstatic.com/draco/v1/decoders/");
    let loader = new THREE.GLTFLoader();
    loader.setDRACOLoader(dracoLoader);
    let glbLoaded = false;
    loader.load(
      "/home.glb",
      function(gltf) {
        const model = gltf.scene;
        model.scale.set(1, 1, 1);
        scene.add(model);
        glbLoaded = true;
        mixer = new THREE.AnimationMixer(model);
        window.mixer = mixer;
        window.bookAnimationClips = gltf.animations;
        window.doorAnimationClips = gltf.animations;
        if (gltf.cameras && gltf.cameras.length > 0) {
          const cameraName = "1\u30AB\u30E1";
          const foundCamera = gltf.cameras.find((cam) => cam.name === cameraName);
          if (foundCamera) {
            customCamera1 = foundCamera;
            customCamera1.up.set(0, 1, 0);
            customCamera1.rotation.y += Math.PI;
            customCamera1.position.z += 1;
          }
        }
        document.getElementById("loading-screen").style.display = "none";
      },
      (xhr) => {
        const percent = (xhr.loaded / xhr.total * 100).toFixed(0);
        document.getElementById("loading-progress").textContent = `Loading: ${percent}%`;
      },
      function(error) {
        console.error("GLB\u8AAD\u307F\u8FBC\u307F\u30A8\u30E9\u30FC:", error);
      }
    );
    camera.position.z = 5;
    const controls = new THREE.OrbitControls(camera, renderer.domElement);
    controls.enableDamping = true;
    controls.dampingFactor = 0.05;
    controls.screenSpacePanning = false;
    controls.maxPolarAngle = Math.PI / 2;
    const bookBtn = document.getElementById("open-book");
    if (bookBtn) {
      bookBtn.addEventListener("click", (e) => {
        e.preventDefault();
        const animationNames = [
          "BookOpen",
          "Action.004",
          "Action.005",
          "Action.006",
          "Action.007",
          "Action.008",
          "Action.009",
          "Action.010",
          "Action.011",
          "Action.012",
          "Action.013",
          "Action.014",
          "Action.015",
          "Action.016",
          "Action.017",
          "Action.018",
          "Action.001",
          "Action.002",
          "Action"
        ];
        if (customCamera1) {
          customCamera1.aspect = camera.aspect;
          customCamera1.updateProjectionMatrix();
          controls.object = customCamera1;
          camera = customCamera1;
          scene.add(camera);
        }
        if (window.mixer && window.bookAnimationClips) {
          let maxDuration = 0;
          animationNames.forEach((name) => {
            const clip = window.bookAnimationClips.find((c) => c.name === name);
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
          }, maxDuration * 1e3);
        } else {
          window.location.href = bookBtn.dataset.roomPath;
        }
      });
    }
    const spotBtn = document.getElementById("open-door");
    if (spotBtn) {
      spotBtn.addEventListener("click", (e) => {
        e.preventDefault();
        const doorNames = [
          "part_key_window.004Action",
          "key_window_hook.003Action"
        ];
        if (window.mixer && window.doorAnimationClips) {
          let maxDuration = 0;
          doorNames.forEach((name) => {
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
            window.location.href = spotBtn.dataset.roomPath;
          }, maxDuration * 1e3);
        } else {
          window.location.href = spotBtn.dataset.roomPath;
        }
      });
    }
    function animate() {
      requestAnimationFrame(animate);
      controls.update();
      const delta = clock.getDelta();
      if (mixer) mixer.update(delta);
      renderer.render(scene, camera);
    }
    animate();
    window.addEventListener("resize", () => {
      const width = canvas.clientWidth;
      const height = canvas.clientHeight;
      renderer.setSize(width, height);
      camera.aspect = width / height;
      camera.updateProjectionMatrix();
    });
  });
})();
//# sourceMappingURL=assets/home.js.map
