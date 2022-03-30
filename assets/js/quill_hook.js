import Quill from "./quill.js";
// import '../quill.snow.css';

export const QuillEditor = {
    mounted() {
      const hook = this;
      const selector = "#" + this.el.id;

      // const input = document.getElementById('quillHiddenInput');
      const editorInstance = new Quill(selector, {theme: 'snow'});
      // let initContent = JSON.parse(input.value || "{}")
      // editorInstance.setContents(initContent)
      editorInstance.on('text-change', function (delta, oldDelta, source) {
        // const contents = editorInstance.getContents();
        const contents = $(".ql-editor").html();
        const plaintext = $(".ql-editor").text();
        // console.log(contents);
        // input.value = JSON.stringify(contents);
        // $("#details-textarea").text(JSON.stringify(contents));
        $("#details-textarea").text(contents);
        $("#details-plaintext-textarea").text(plaintext);

        console.log($("#details-plaintext-textarea").text());
      });
    }
  };