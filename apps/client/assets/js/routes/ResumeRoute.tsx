import * as React from "react";
import { MainNav, ActiveItem } from "./../components/MainNav";
import { PdfViewer } from "./../components/PdfViewer";
import { StyleSheet, css } from "aphrodite";
import { Button } from "semantic-ui-react";
const pdfPath = require("./../../static/files/resume.pdf");
const docPath = require("./../../static/files/resume.docx");

const style = StyleSheet.create({
  resumeContainer: {
    display: "flex",
    justifyContent: "center"
  },

  actionsContainer: {
    display: "flex",
    alignItems: "center",
    flexDirection: "column"
  },

  actions: {
    display: "flex",
    marginTop: "1rem"
  }
});

export const ResumeRoute = () => (
  <div>
    <MainNav activeItem={ActiveItem.Settings} />

    <div className={css(style.resumeContainer)}>
      <PdfViewer pdfPath={pdfPath} />
    </div>

    <div className={css(style.actionsContainer)}>
      <div className={css(style.actions)}>
        <Button onClick={openPdf}>Save as pdf</Button>
        <Button onClick={openDoc}>Save as docx</Button>
      </div>
    </div>
  </div>
);

const openPdf = () => openFile(pdfPath);
const openDoc = () => openFile(docPath);

const openFile = (file: string) => {
  const link = document.createElement("a");
  link.download = "Resume of Justin Toniazzo";
  link.href = file;
  link.click();
};
