import * as React from 'react';
import { PDFJSStatic, PDFDocumentProxy, PDFPageProxy } from 'pdfjs-dist';
const PDFJS: PDFJSStatic = require('pdfjs-dist');
const workerPath = require('pdfjs-dist/build/pdf.worker');

interface IProps {
  pdfPath: string;
}

interface IState {
  canvasId: string;
}

class _PdfViewer extends React.Component<IProps, IState> {
  public constructor(props: IProps) {
    super(props);

    this.state = {
      canvasId: `the-canvas-${Math.random()}-${Math.random()}`
    }

    PDFJS.workerSrc = workerPath;
    PDFJS.getDocument(this.props.pdfPath).then(
      this.onRenderSuccess,
      this.onRenderFailure
    );
  }

  private onRenderSuccess = (pdf: PDFDocumentProxy) => {
    pdf.getPage(1).then((page: PDFPageProxy) => {
      console.log('Page loaded');
      const scale = 1.5;
      const viewport = page.getViewport(scale);

      // Prepare canvas using PDF page dimensions
      const canvasId = this.state.canvasId;
      const canvas = document.getElementById(canvasId) as HTMLCanvasElement;
      const context = canvas.getContext('2d');
      canvas.height = viewport.height;
      canvas.width = viewport.width;

      // Render PDF page into canvas context
      const renderContext = {
        canvasContext: context,
        viewport: viewport
      };

      const renderTask = page.render(renderContext);
      renderTask.then(function () {
        console.log('Page rendered');
      });
    });
  }

  private onRenderFailure = (reason: string) => {
    console.error(reason);
  };

  public render() {
    return (
      <canvas id={this.state.canvasId} />
    );
  }
}

export const PdfViewer = _PdfViewer;
