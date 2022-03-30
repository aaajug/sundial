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
      // editorInstance.on('text-change', function (delta, oldDelta, source) {
      //   const contents = editorInstance.getContents();
      //   // input.value = JSON.stringify(contents);

        
      // });
    }
  };