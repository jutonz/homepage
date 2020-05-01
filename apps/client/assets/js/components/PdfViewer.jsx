import React from "react";
const PDFJS = require("pdfjs-dist");
const workerPath = require("pdfjs-dist/build/pdf.worker");

class _PdfViewer extends React.Component {
  constructor(props) {
    super(props);

    this.state = {
      canvasId: `the-canvas-${Math.random()}-${Math.random()}`,
    };

    PDFJS.workerSrc = workerPath;
    PDFJS.getDocument(this.props.pdfPath).then(
      this.onRenderSuccess,
      this.onRenderFailure
    );
  }

  onRenderSuccess = (pdf) => {
    pdf.getPage(1).then((page) => {
      this.renderPage(page);
    });
  };

  componentDidMount() {
    window.addEventListener("resize", () => {
      const page = this.state.page;
      if (page) {
        this.renderPage(page); // rescale
      }
    });
  }

  renderPage(page) {
    this.setState({ page });
    console.log("Page loaded");
    const canvasId = this.state.canvasId;
    const canvas = document.getElementById(canvasId);

    const scale = this.optimumScale(page, canvas);
    console.log("optimum scale is", scale);
    const viewport = page.getViewport(scale);

    // Prepare canvas using PDF page dimensions
    const context = canvas.getContext("2d");
    const { height, width } = viewport;
    canvas.height = height;
    canvas.width = width;

    // Render PDF page into canvas context
    const renderContext = {
      canvasContext: context,
      viewport: viewport,
    };

    const renderTask = page.render(renderContext);
    renderTask.then(() => console.log("Page rendered"));
  }

  optimumScale(page, canvas) {
    return canvas.clientHeight / page.getViewport(1.0).height;
  }

  onRenderFailure = (reason) => {
    console.error(reason);
  };

  render() {
    return <canvas id={this.state.canvasId} />;
  }
}

export const PdfViewer = _PdfViewer;
