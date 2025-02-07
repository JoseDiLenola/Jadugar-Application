# UI/UX Guidelines

## Design Principles

### 1. Clarity
- Clear hierarchy
- Consistent layouts
- Obvious actions
- Meaningful feedback

### 2. Efficiency
- Minimal clicks
- Keyboard shortcuts
- Quick access to common tasks
- Efficient data entry

### 3. Consistency
- Consistent patterns
- Standard components
- Predictable behavior
- Unified terminology

### 4. Feedback
- Clear status indicators
- Meaningful error messages
- Progress indicators
- Success confirmations

## Color Palette

### Primary Colors
```css
--primary-50:  #f0f9ff;
--primary-100: #e0f2fe;
--primary-200: #bae6fd;
--primary-300: #7dd3fc;
--primary-400: #38bdf8;
--primary-500: #0ea5e9;
--primary-600: #0284c7;
--primary-700: #0369a1;
--primary-800: #075985;
--primary-900: #0c4a6e;
```

### Neutral Colors
```css
--neutral-50:  #f8fafc;
--neutral-100: #f1f5f9;
--neutral-200: #e2e8f0;
--neutral-300: #cbd5e1;
--neutral-400: #94a3b8;
--neutral-500: #64748b;
--neutral-600: #475569;
--neutral-700: #334155;
--neutral-800: #1e293b;
--neutral-900: #0f172a;
```

### Semantic Colors
```css
--success-500: #22c55e;
--warning-500: #f59e0b;
--error-500:   #ef4444;
--info-500:    #3b82f6;
```

## Typography

### Font Family
```css
--font-sans: 'Inter', system-ui, sans-serif;
--font-mono: 'JetBrains Mono', monospace;
```

### Font Sizes
```css
--text-xs:  0.75rem;
--text-sm:  0.875rem;
--text-base: 1rem;
--text-lg:  1.125rem;
--text-xl:  1.25rem;
--text-2xl: 1.5rem;
--text-3xl: 1.875rem;
--text-4xl: 2.25rem;
```

### Font Weights
```css
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
```

## Spacing

### Base Units
```css
--spacing-px: 1px;
--spacing-0:  0;
--spacing-1:  0.25rem;
--spacing-2:  0.5rem;
--spacing-3:  0.75rem;
--spacing-4:  1rem;
--spacing-5:  1.25rem;
--spacing-6:  1.5rem;
--spacing-8:  2rem;
--spacing-10: 2.5rem;
--spacing-12: 3rem;
--spacing-16: 4rem;
```

## Components

### Buttons

#### Primary Button
```tsx
<Button variant="primary" size="md">
  Primary Action
</Button>
```

#### Secondary Button
```tsx
<Button variant="secondary" size="md">
  Secondary Action
</Button>
```

#### Button Sizes
- xs: 24px height
- sm: 32px height
- md: 40px height
- lg: 48px height

### Forms

#### Text Input
```tsx
<Input
  label="Label"
  placeholder="Enter value"
  helperText="Helper text"
/>
```

#### Select
```tsx
<Select
  label="Label"
  options={options}
  placeholder="Select option"
/>
```

### Cards

#### Basic Card
```tsx
<Card>
  <CardHeader>Title</CardHeader>
  <CardBody>Content</CardBody>
  <CardFooter>Actions</CardFooter>
</Card>
```

## Layout

### Grid System
- 12-column grid
- Responsive breakpoints
- Consistent gutters

### Breakpoints
```css
--screen-sm: 640px;
--screen-md: 768px;
--screen-lg: 1024px;
--screen-xl: 1280px;
--screen-2xl: 1536px;
```

### Container Widths
```css
--container-sm: 640px;
--container-md: 768px;
--container-lg: 1024px;
--container-xl: 1280px;
```

## Icons

### Icon System
- Use Phosphor Icons
- Consistent sizes
- Semantic usage
- Color inheritance

### Icon Sizes
```css
--icon-sm: 16px;
--icon-md: 20px;
--icon-lg: 24px;
--icon-xl: 32px;
```

## Animations

### Durations
```css
--duration-75: 75ms;
--duration-100: 100ms;
--duration-150: 150ms;
--duration-200: 200ms;
--duration-300: 300ms;
```

### Timing Functions
```css
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);
--ease-in: cubic-bezier(0.4, 0, 1, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
```

## Best Practices

### Accessibility
- WCAG 2.1 AA compliance
- Keyboard navigation
- Screen reader support
- Sufficient color contrast

### Responsive Design
- Mobile-first approach
- Fluid typography
- Flexible layouts
- Touch-friendly targets

### Performance
- Lazy loading
- Code splitting
- Image optimization
- Minimal dependencies

### Error Handling
- Clear error messages
- Recovery options
- Guided resolution
- Persistent state

## Implementation

### CSS Architecture
- CSS Modules
- Utility-first with Tailwind
- Custom properties
- Consistent naming

### Component Structure
```tsx
// Component.tsx
export interface Props {
  // Props interface
}

export const Component: React.FC<Props> = ({
  // Implementation
})

// Component.module.css
.root {
  // Styles
}
```

### Documentation
- Storybook stories
- Props documentation
- Usage examples
- Accessibility notes
