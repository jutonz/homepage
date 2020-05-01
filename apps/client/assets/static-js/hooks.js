export default {
  FoodLogEntryInput: {
    mounted() {
      this.el.focus();
    },
  },

  FoodLogEntryUpdateInput: {
    mounted() {
      this.el.focus();

      let value = this.el.value;
      this.el.setSelectionRange(value.length, value.length);
    },
  },
};
