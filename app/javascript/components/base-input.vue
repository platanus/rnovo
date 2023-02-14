<script setup lang="ts">
import { useField } from 'vee-validate';
import { useAttrs } from 'vue';

interface Props {
  type?: 'text' | 'number';
  modelValue?: string | number;
  label: string;
  placeholder?: string;
  name: string;
  is?: string;
  required?: boolean;
  labelHint?: string;
}

const props = withDefaults(defineProps<Props>(), {
  type: 'text',
  is: 'input',
  modelValue: undefined,
  placeholder: undefined,
  labelHint: undefined,
});

const {
  value: inputValue,
  errorMessage,
  handleBlur,
  handleChange,
} = useField(props.name, undefined, {
  initialValue: props.modelValue,
});

const attrs = useAttrs();
const attrsWithoutClass = Object.fromEntries(Object.entries(attrs).filter(([key, _]) => key !== 'class'));
</script>

<script lang="ts">
// eslint-disable-next-line import/no-default-export
export default {
  inheritAttrs: false,
};
</script>

<template>
  <div :class="$attrs.class">
    <base-label
      :label="label"
      :name="name"
      :required="required"
      :label-hint="labelHint"
    />
    <div class="flex">
      <slot name="before" />
      <component
        v-bind="attrsWithoutClass"
        :is="is"
        :id="name"
        :value="inputValue"
        :placeholder="placeholder"
        :name="name"
        :type="type"
        class="w-full rounded border border-gray-300 py-2.5 px-4 text-sm"
        :class="[{
          'text-red-600 border-red-600': !!errorMessage,
          'rounded-l-none': $slots.before,
          'bg-gray-100 opacity-75': $attrs.disabled
        }]"
        @input="handleChange"
        @blur="handleBlur"
      />
    </div>
    <p
      v-show="errorMessage"
      class="text-right text-xs text-red-600"
    >
      {{ errorMessage }}
    </p>
  </div>
</template>
