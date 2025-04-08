<template>
  <div>
    <v-click v-for="(item, index) in processedItems" :key="index">
      <component :is="item" />
    </v-click>
  </div>
</template>

<script>
export default {
  computed: {
    processedItems() {
      const slotContent = this.$slots.default ? this.$slots.default() : [];
      return slotContent.map(node => {

        if (node.type === 'li' && node.children) {
          return node
        }
      })
    }
  }
}
</script>
