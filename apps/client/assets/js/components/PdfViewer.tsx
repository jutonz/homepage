import * as React from "react";
import { PDFJSStatic, PDFDocumentProxy, PDFPageProxy } from "pdfjs-dist";
const PDFJS: PDFJSStatic = require("pdfjs-dist");
const workerPath = require("pdfjs-dist/build/pdf.worker");

interface IProps {
  pdfPath: string;
}

interface IState {
  canvasId: string;
  page?: PDFPageProxy;
}

class _PdfViewer extends React.Component<IProps, IState> {
  public constructor(props: IProps) {
    super(props);

    this.state = {
      canvasId: `the-canvas-${Math.random()}-${Math.random()}`
    };

    PDFJS.workerSrc = workerPath;
    PDFJS.getDocument(this.props.pdfPath).then(
      this.onRenderSuccess,
      this.onRenderFailure
    );
  }

  private onRenderSuccess = (pdf: PDFDocumentProxy) => {
    pdf.getPage(1).then((page: PDFPageProxy) => {
      this.renderPage(page);
    });
  };

  public componentDidMount() {
    console.log("Hey I mounted");
    window.addEventListener("resize", () => {
      const page = this.state.page;
      if (page) {
        this.renderPage(page); // rescale
      }
    });
  }

  private renderPage(page: PDFPageProxy) {
    this.setState({ page });
    console.log("Page loaded");
    const canvasId = this.state.canvasId;
    const canvas = document.getElementById(canvasId) as HTMLCanvasElement;

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
      viewport: viewport
    };

    const renderTask = page.render(renderContext);
    renderTask.then(() => console.log("Page rendered"));
  };

  private optimumScale(page: PDFPageProxy, canvas: HTMLCanvasElement) {
    return canvas.clientHeight / page.getViewport(1.0).height;
  };

  private onRenderFailure = (reason: string) => {
    console.error(reason);
  };

  public render() {
    return <canvas id={this.state.canvasId} />;
  }
}

export const PdfViewer = _PdfViewer;
