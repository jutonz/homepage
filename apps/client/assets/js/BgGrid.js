import Globals from "./style-globals";
import {
  PerspectiveCamera,
  Scene,
  WebGLRenderer,
  LineBasicMaterial,
  Vector3,
  BufferGeometry,
  Line,
} from "three";

export class BgGrid {
  init() {
    this.scene = new Scene();
    this.camera = new PerspectiveCamera(
      75,
      window.innerWidth / window.innerHeight,
      0.1,
      1000,
    );

    const canvas = document.getElementById("gl-canvas");
    this.renderer = new WebGLRenderer({ canvas });
    this.recalculateRenderingDimensions();

    this.addLine();

    this.camera.position.z = 10;

    window.addEventListener("resize", () => {
      this.recalculateRenderingDimensions();
    });
  }

  start() {
    this.animate();
  }

  animate() {
    requestAnimationFrame((timestamp) => this.animate(timestamp));

    this.squares.forEach((square, index) => {
      square.rotateZ(0.00001 * index);
    });

    this.renderer.render(this.scene, this.camera);
  }

  addLine() {
    const material = new LineBasicMaterial({ color: Globals.brandPrimary });
    const points = [
      new Vector3(-10, 0, 0),
      new Vector3(0, 10, 0),
      new Vector3(10, 0, 0),
      new Vector3(0, -10, 0),
      new Vector3(-10, 0, 0),
    ];

    const geometry = new BufferGeometry().setFromPoints(points);
    this.square = new Line(geometry, material);

    this.squares = [this.square];

    for (let i = 0; i < 100; i++) {
      let newSquare = this.square.clone();
      newSquare.rotateZ(0.01 * i);
      newSquare.position.z = 0.07 * i;
      this.squares.push(newSquare);
    }

    this.squares.forEach((square) => this.scene.add(square));
  }

  recalculateRenderingDimensions() {
    let innerHeight = window.innerHeight;
    let innerWidth = window.innerWidth;
    this.renderer.setSize(innerWidth, innerHeight);

    let aspect = innerWidth / innerHeight;
    this.camera.aspect = aspect;
    this.renderer.setPixelRatio(window.devicePixelRatio);
    this.camera.updateProjectionMatrix();
  }
}
