<template>
<ul>
    <v-click v-for="(item, index) in processedItems" :key="index">
      <component :is="item" />
    </v-click>
    </ul>
</template>

<script>
import { h } from 'vue'

export default {
  computed: {
    processedItems() {
      const slotContent = this.$slots.default ? this.$slots.default() : [];
      return slotContent.flatMap(node => {

        if (node.type === 'li' && node.children) {
          return node
        }
        if (node.type === 'ul') {
          return node.children
        }
        if (node.type.toString() === "Symbol(v-txt)"){
          const item = h('li', node.children.substr(2))
          return item
        }
        
      })
    }
  }
}
</script>
