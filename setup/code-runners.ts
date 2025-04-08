import { defineCodeRunnersSetup } from '@slidev/types'
import { exec } from 'child_process'

export default defineCodeRunnersSetup(() => {
  return {
    async bash(code, ctx) {
      return new Promise((resolve, reject) => {
        exec(code, (error, stdout, stderr) => {
          if (error) {
            resolve({ text: `Error: ${stderr}` })
          } else {
            resolve({ text: stdout })
          }
        })
      })
    },
    // You can add more custom runners for other languages here
  }
})
