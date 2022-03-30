import Quill from "./quill.js";
import '../quill.snow.css';

export default {
    mounted() {
      const hook = this;

      console.log("IN quill hook quillEditor ...");
      // const input = document.getElementById('quillHiddenInput');
      const editorInstance = new Quill(this.el.id, {theme: 'snow'});
      console.log("editorInstance: " + editorInstance);
      // let initContent = JSON.parse(input.value || "{}")
      // editorInstance.setContents(initContent)
      editorInstance.on('text-change', function (delta, oldDelta, source) {
        const contents = editorInstance.getContents();
        // input.value = JSON.stringify(contents);

        
      });
      console.log("end of quill hook");
    }
  };