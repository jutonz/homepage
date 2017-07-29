// Brunch automatically concatenates all files in your watched paths. Those
// paths can be configured at config.paths.watched in "brunch-config.js".
//
// However, those files will only be executed if explicitly imported. The only
// exception are files in vendor, which are never wrapped in imports and
// therefore are always executed.

// Import dependencies
//
// If you no longer want to use a dependency, remember to also remove its path
// from "config.paths.watched".
import 'phoenix_html';
import 'react-phoenix';
//import 'three';
import * as THREE from 'three';
//import THREE from 'three';

// Import local files
//
// Local files can be imported directly using relative paths "./socket" or full
// ones "web/static/js/socket".
// import socket from './socket';
import MainNav from './components/MainNav';
import Timer from './components/Timer';
import Hello from './components/Hello';
import Login from './components/Login';
import TextField from './components/TextField';
import Button from './components/Button';

window.Components = {
  MainNav,
  Timer,
  Hello,
  Login,
  TextField,
  Button
};

window.addEventListener('load', animateBackground);
window.addEventListener('resize', recalculateRenderingDimensions);

function animateBackground() {
  //init();
  //animate();
  initPlane();
  //animatePlane();
}

let scene, camera, renderer;
let geometry, material, mesh;

function initPlane() {
  let { innerHeight, innerWidth } = window;

  scene = new THREE.Scene();

  let aspect = innerWidth / innerHeight;
  camera = new THREE.PerspectiveCamera(75, aspect, 1, 10000);
  camera.position.z = 500;

  const segmentSize = 50; // each segment is segmentSize x segmentSize big
  let geoWidth = innerWidth * 2;
  let geoHeight = innerHeight * 2;
  let widthSegments = geoWidth / segmentSize;
  let heightSegments = geoHeight / segmentSize;
  geometry = new THREE.PlaneGeometry(geoWidth, geoHeight, widthSegments, heightSegments);
  material = new THREE.MeshBasicMaterial({ color: 0xAC17C6, wireframe: true });

  mesh = new THREE.Mesh(geometry, material);
  //mesh.rotation.x = 150;
  //mesh.rotation.y = -100;
  mesh.rotation.x = -0.25;
  mesh.rotation.y = 0.25;
  mesh.rotation.z = 0.2;
  scene.add(mesh);

  let canvas = document.getElementById('gl-canvas');
  renderer = new THREE.WebGLRenderer({ canvas: canvas });
  recalculateRenderingDimensions();
  renderer.render(scene, camera);
}

function animatePlane() {
  requestAnimationFrame(animatePlane);
  //mesh.rotation.z += 0.0005;
  renderer.render(scene, camera);
}

function init() {
  scene = new THREE.Scene();

  camera = new THREE.PerspectiveCamera(75, window.innerWidth / window.innerHeight, 1, 10000);
  camera.position.z = 1000;

  geometry = new THREE.BoxGeometry(200, 200, 200);
  material = new THREE.MeshBasicMaterial({ color: 0xAC17C6, wireframe: true });

  mesh = new THREE.Mesh(geometry, material);
  scene.add(mesh);

  let canvas = document.getElementById('gl-canvas');
  renderer = new THREE.WebGLRenderer({ canvas: canvas });
  renderer.setSize(window.innerWidth, window.innerHeight);
  renderer.setPixelRatio(window.devicePixelRatio);
}

function animate() {
  requestAnimationFrame(animate);

  //mesh.rotation.x += 0.01;
  //mesh.rotation.y += 0.01;
  mesh.rotation.z += 0.01;

  renderer.render(scene, camera);
}

function recalculateRenderingDimensions() {
  let { innerHeight, innerWidth } = window;
  renderer.setSize(innerWidth, innerHeight);

  let aspect = innerWidth / innerHeight;
  camera.aspect = aspect;
  renderer.setPixelRatio(window.devicePixelRatio);
  camera.updateProjectionMatrix();
  console.log(`resized viewport to ${innerWidth}x${innerHeight}`);
}
