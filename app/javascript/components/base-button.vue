<script setup lang="ts">
import { computed, useAttrs } from 'vue';

const props = withDefaults(defineProps<{
  isDisabled?: boolean
  size?: 'md' | 'lg'
  variant?: 'primary' | 'tertiary' | 'disabled'
}>(), {
  isDisabled: false,
  size: 'md',
  variant: 'primary',
});
const attrs = useAttrs();
const currentTag = computed(() => (attrs.href ? 'a' : 'button'));
const sizes = {
  md: 'h-9 text-sm px-5',
  lg: 'h-11 text-lg px-7',
};
const colors = {
  primary: 'text-gray-800 bg-orange-400',
  tertiary: 'text-gray-600 bg-white border border-gray-600',
  disabled: 'text-gray-500 bg-gray-300',
};
const currentClasses = computed(() => {
  const color = colors[props.variant];
  const size = sizes[props.size];

  return [color, size].join(' ');
});
</script>

<template>
  <component
    :is="currentTag"
    class="inline-flex shrink-0 items-center justify-center rounded-md text-center"
    :class="currentClasses"
    :disabled="isDisabled"
  >
    <slot />
  </component>
</template>
