import { defineCodeRunnersSetup } from '@slidev/types'
import { exec } from 'child_process'

console.log("Loaded!")
export default defineCodeRunnersSetup(() => {
  return {
    async bash(code, ctx) {
      const { promisify } = require('util');
      const exec = promisify(require('child_process').exec);

      try {
        const { stdout, stderr } = await exec(code);
        if (stderr) {
          return { text: `Error: ${stderr}` };
        }
        return { text: stdout };
      } catch (error) {
        return { text: `Execution error: ${error.message}` };
      }
    },
    // You can add more custom runners for other languages here
  }
})
