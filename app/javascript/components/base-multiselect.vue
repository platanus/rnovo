<script setup lang="ts">
import { useField } from 'vee-validate';
import Multiselect from 'vue-multiselect';

interface Props {
  modelValue?: [ string | number ];
  options: { id: string; name: string }[];
  label: string;
  name: string;
  placeholder?: string;
  required?: boolean;
  labelHint?: string;
  searchable?: boolean;
}

const props = withDefaults(defineProps<Props>(), {
  modelValue: undefined,
  labelHint: undefined,
  placeholder: undefined,
  searchable: false,
});

const {
  value: inputValue,
  errorMessage,
  handleBlur,
} = useField(props.name, undefined, {
  initialValue: props.modelValue,
  valueProp: props.modelValue,
});
</script>

<template>
  <div>
    <BaseLabel
      :label="label"
      :name="name"
      :required="required"
      :label-hint="labelHint"
    />
    <div class="flex">
      <multiselect
        v-model="inputValue"
        multiple
        :options="options"
        :searchable="searchable"
        :placeholder="placeholder"
        :class="[{'text-red-600 border-red-600': !!errorMessage}]"
        label="name"
        track-by="id"
        @blur="handleBlur"
      />
    </div>
    <p
      v-show="errorMessage"
      class="text-right text-xs text-red-600 md:col-span-2"
    >
      {{ errorMessage }}
    </p>
  </div>
</template>

<style src="vue-multiselect/dist/vue-multiselect.css"></style>

<style lang="scss">
.multiselect {
  @apply border border-slate-200 rounded-lg bg-white text-sm;
  &__active {
    @apply text-sm;
  }
  &__select {
    @apply bg-white;
}
  &__tags {
    @apply  bg-white border border-slate-200;
  }
  &__option:hover {
    @apply text-sm bg-orange-400 text-black;
  }
  &__option--highlight {
    @apply text-sm bg-orange-400 text-black;
  }
  &__tag {
    @apply text-sm bg-orange-400 text-black;
  }
  &__option--selected.multiselect__option--highlight,
  &__option--selected.multiselect__option--highlight:after {
    @apply text-red-400 bg-red-100;
  }

}
</style>
