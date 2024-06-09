function setupDisplacementSlider() {
  const displacementSlider = function (opts) {
    let vertex = `
      varying vec2 vUv;
      void main() {
        vUv = uv;
        gl_Position = projectionMatrix * modelViewMatrix * vec4( position, 1.0 );
      }
    `;

    let fragment = `
      varying vec2 vUv;
      uniform sampler2D currentImage;
      uniform sampler2D nextImage;
      uniform float dispFactor;
      void main() {
        vec2 uv = vUv;
        vec4 _currentImage;
        vec4 _nextImage;
        float intensity = 0.3;
        vec4 orig1 = texture2D(currentImage, uv);
        vec4 orig2 = texture2D(nextImage, uv);
        _currentImage = texture2D(currentImage, vec2(uv.x, uv.y + dispFactor * (orig2 * intensity)));
        _nextImage = texture2D(nextImage, vec2(uv.x, uv.y + (1.0 - dispFactor) * (orig1 * intensity)));
        vec4 finalTexture = mix(_currentImage, _nextImage, dispFactor);
        gl_FragColor = finalTexture;
      }
    `;

    let images = opts.images,
        image,
        sliderImages = [];
    let canvasWidth = images[0].clientWidth;
    let canvasHeight = images[0].clientHeight;
    let parent = opts.parent;
    let renderWidth = Math.max(
        document.documentElement.clientWidth,
        window.innerWidth || 0
    );
    let renderHeight = Math.max(
        document.documentElement.clientHeight,
        window.innerHeight || 0
    );

    let renderW, renderH;

    if (renderWidth > canvasWidth) {
      renderW = renderWidth;
    } else {
      renderW = canvasWidth;
    }

    renderH = canvasHeight;

    let renderer = new THREE.WebGLRenderer({
      antialias: false
    });

    renderer.setPixelRatio(window.devicePixelRatio);
    renderer.setClearColor(0x23272a, 1.0);
    renderer.setSize(renderW, renderH);
    parent.appendChild(renderer.domElement);

    let loader = new THREE.TextureLoader();
    loader.crossOrigin = "anonymous";

    images.forEach((img) => {
      image = loader.load(img.getAttribute("src") + "?v=" + Date.now());
      image.magFilter = image.minFilter = THREE.LinearFilter;
      image.anisotropy = renderer.capabilities.getMaxAnisotropy();
      sliderImages.push(image);
    });

    let scene = new THREE.Scene();
    scene.background = new THREE.Color(0x23272a);
    let camera = new THREE.OrthographicCamera(
        renderWidth / -2,
        renderWidth / 2,
        renderHeight / 2,
        renderHeight / -2,
        1,
        1000
    );

    camera.position.z = 1;

    let mat = new THREE.ShaderMaterial({
      uniforms: {
        dispFactor: { type: "f", value: 0.0 },
        currentImage: { type: "t", value: sliderImages[0] },
        nextImage: { type: "t", value: sliderImages[1] }
      },
      vertexShader: vertex,
      fragmentShader: fragment,
      transparent: true,
      opacity: 1.0
    });

    let geometry = new THREE.PlaneBufferGeometry(
        parent.offsetWidth,
        parent.offsetHeight,
        1
    );
    let object = new THREE.Mesh(geometry, mat);
    object.position.set(0, 0, 0);
    scene.add(object);

    let addEvents = function () {
      let pagButtons = Array.from(
          document.getElementById("pagination").querySelectorAll("button")
      );
      let isAnimating = false;

      pagButtons.forEach((el) => {
        el.addEventListener("click", function () {
          if (!isAnimating) {
            isAnimating = true;

            document
                .getElementById("pagination")
                .querySelector(".active").classList.remove("active");
            this.classList.add("active");

            let slideId = parseInt(this.dataset.slide, 10);

            mat.uniforms.nextImage.value = sliderImages[slideId];
            mat.uniforms.nextImage.needsUpdate = true;

            gsap.to(mat.uniforms.dispFactor, {
              value: 1,
              duration: 1,
              ease: "expo.inOut",
              onComplete: function () {
                mat.uniforms.currentImage.value = sliderImages[slideId];
                mat.uniforms.currentImage.needsUpdate = true;
                mat.uniforms.dispFactor.value = 0.0;
                isAnimating = false;

                // Activate the corresponding slider item
                document.querySelectorAll('.slider-item').forEach(item => item.classList.remove('active'));
                document.querySelector(`.slider-item[data-slide-index="${slideId}"]`).classList.add('active');
              }
            });

            let slideTitleEl = document.getElementById("slide-title");
            let slideStatusEl = document.getElementById("slide-status");
            let nextSlideTitle = document.querySelector(
                `[data-slide-title="${slideId}"]`
            ).innerHTML;
            let nextSlideStatus = document.querySelector(
                `[data-slide-status="${slideId}"]`
            ).innerHTML;

            gsap.fromTo(
                slideTitleEl,
                { autoAlpha: 1, y: 0 },
                {
                  autoAlpha: 0,
                  y: 20,
                  duration: 0.5,
                  ease: "expo.in",
                  onComplete: function () {
                    slideTitleEl.innerHTML = nextSlideTitle;
                    gsap.to(slideTitleEl, { autoAlpha: 1, y: 0, duration: 0.5 });
                  }
                }
            );

            gsap.fromTo(
                slideStatusEl,
                { autoAlpha: 1, y: 0 },
                {
                  autoAlpha: 0,
                  y: 20,
                  duration: 0.5,
                  ease: "expo.in",
                  onComplete: function () {
                    slideStatusEl.innerHTML = nextSlideStatus;
                    gsap.to(slideStatusEl, {
                      autoAlpha: 1,
                      y: 0,
                      duration: 0.5,
                      delay: 0.1
                    });
                  }
                }
            );
          }
        });
      });
    };

    addEvents();

    window.addEventListener("resize", function () {
      renderer.setSize(renderW, renderH);
    });

    let animate = function () {
      requestAnimationFrame(animate);
      renderer.render(scene, camera);
    };
    animate();
  };

  imagesLoaded(document.querySelectorAll("img"), () => {
    document.body.classList.remove("loading");

    const el = document.getElementById("slider");
    if (el) {
      const imgs = Array.from(el.querySelectorAll("img"));
      if (imgs.length > 0) {
        new displacementSlider({
          parent: el,
          images: imgs
        });
      } else {
        console.error("No images found in slider");
      }
    } else {
      console.error("Slider element not found");
    }
  });


  const buttons = document.querySelectorAll('#pagination button');
  const slides = document.querySelectorAll('#slider-content .slide');
  const images = document.querySelectorAll('#slider img');

  buttons.forEach(button => {
    button.addEventListener('click', function() {
      const slideIndex = this.getAttribute('data-slide');

      buttons.forEach(btn => btn.classList.remove('active'));
      this.classList.add('active');

      slides.forEach(slide => slide.style.display = 'none');
      images.forEach(img => img.classList.add('hidden'));

      document.querySelector(`#slider-content .slide[data-slide-index="${slideIndex}"]`).style.display = 'block';
      images[slideIndex].classList.remove('hidden');
    });
  });
}

function setupToggleComments() {
  const toggleButton = document.getElementById('toggle-comments');
  const commentsSection = document.getElementById('comments-section');

  if (toggleButton && commentsSection) {
    toggleButton.addEventListener('click', function() {
      if (commentsSection.style.display === 'none') {
        commentsSection.style.display = 'block';
    
      } else {
        commentsSection.style.display = 'none';
    ;
      }
    });
  }
}

document.addEventListener('DOMContentLoaded', () => {
  setupDisplacementSlider();
  setupToggleComments();
});

document.addEventListener("turbo:load", () => {
  setupDisplacementSlider();
  setupToggleComments();

  var closeButtons = document.querySelectorAll(".alert-close");
  closeButtons.forEach(function(button) {
    button.addEventListener("click", function() {
      var alertBox = this.parentElement;
      alertBox.style.display = "none";
    });
  });

  var alertBoxes = document.querySelectorAll(".alert");
  alertBoxes.forEach(function(box) {
    setTimeout(function() {
      box.style.display = "none";
    }, 5000);
  });
});

function toggleMenu() {
  var menu = document.getElementById('dropdownMenu');
  menu.classList.toggle('hidden');
}
