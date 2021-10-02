import React from "react";
import { StyleSheet, css } from "aphrodite";
import { Button } from "semantic-ui-react";
import { MainNav } from "./../components/MainNav";
import { PdfViewer } from "./../components/PdfViewer";

const { host, protocol } = window.location;
const FULL_HOSTNAME = `${protocol}//${host}`;
const PDF_PATH = FULL_HOSTNAME + "/files/resume.pdf";
const DOC_PATH = FULL_HOSTNAME + "/files/resume.docx";

const style = StyleSheet.create({
  resumeContainer: {
    display: "flex",
    justifyContent: "center",
    height: "80vh",
  },

  actionsContainer: {
    display: "flex",
    alignItems: "center",
    flexDirection: "column",
  },

  actions: {
    display: "flex",
    marginTop: "1rem",
  },
});

export const ResumeRoute = () => (
  <div>
    <MainNav activeItem={"resume"} />

    <div className={css(style.resumeContainer)}>
      <PdfViewer pdfPath={PDF_PATH} />
    </div>

    <div className={css(style.actionsContainer)}>
      <div className={css(style.actions)}>
        <Button onClick={openPdf}>Save as pdf</Button>
        <Button onClick={openDoc}>Save as docx</Button>
      </div>
    </div>
  </div>
);

const openPdf = () => openFile(PDF_PATH);
const openDoc = () => openFile(DOC_PATH);

const openFile = (file) => {
  const link = document.createElement("a");
  link.download = "Resume of Justin Toniazzo";
  link.href = file;
  link.click();
};
