import Quill from "./quill.js";
// import '../quill.snow.css';

export const QuillEditor = {
    mounted() {
      const hook = this;
      const selector = "#" + this.el.id;

      const editorInstance = new Quill(selector, {theme: 'snow'});

      editorInstance.on('text-change', function (delta, oldDelta, source) {
        const contents = $(".ql-editor").html();
        const plaintext = $(".ql-editor").text();
        $("#details-textarea").text(contents);
        $("#details-plaintext-textarea").text(plaintext);
      });
    }
  };