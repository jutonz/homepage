import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Button } from "semantic-ui-react";
import { MainNav } from "@components/MainNav";
import { PdfViewer } from "@components/PdfViewer";
import pdfPath from "@static/files/resume.pdf";
import docPath from "@static/files/resume.docx";

const style = StyleSheet.create({
  resumeContainer: {
    display: "flex",
    justifyContent: "center",
    height: "80vh"
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
    <MainNav activeItem={"resume"} />

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

const openFile = file => {
  const link = document.createElement("a");
  link.download = "Resume of Justin Toniazzo";
  link.href = file;
  link.click();
};
