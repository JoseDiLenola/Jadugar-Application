# @jadugar/ui Theme System

This document specifies the theme system implementation for the Jadugar UI package. The theme system provides comprehensive theming capabilities with dynamic theme switching, customization, and design token management.

## Theme Architecture

### Theme Manager

```typescript
interface ThemeOptions {
  themes?: Theme[];
  defaultTheme?: string;
  tokens?: ThemeTokens;
  plugins?: ThemePlugin[];
}

class ThemeManager {
  constructor(options: ThemeOptions);
  
  // Theme Operations
  setTheme(name: string): void;
  getTheme(): Theme;
  
  // Theme Management
  register(theme: Theme): void;
  unregister(name: string): void;
  
  // Configuration
  configure(options: ThemeOptions): void;
  getConfig(): ThemeConfig;
}
```

## Design Tokens

### Token System

```typescript
interface ThemeTokens {
  colors: ColorTokens;
  typography: TypographyTokens;
  spacing: SpacingTokens;
  breakpoints: BreakpointTokens;
  animation: AnimationTokens;
  elevation: ElevationTokens;
}

interface ColorTokens {
  // Brand Colors
  primary: ColorScale;
  secondary: ColorScale;
  accent: ColorScale;
  
  // Semantic Colors
  success: ColorScale;
  warning: ColorScale;
  error: ColorScale;
  info: ColorScale;
  
  // Neutral Colors
  background: ColorScale;
  surface: ColorScale;
  border: ColorScale;
  text: ColorScale;
}

interface TypographyTokens {
  // Font Families
  families: {
    heading: string;
    body: string;
    mono: string;
  };
  
  // Font Sizes
  sizes: {
    xs: string;
    sm: string;
    md: string;
    lg: string;
    xl: string;
    '2xl': string;
    '3xl': string;
  };
  
  // Font Weights
  weights: {
    light: number;
    regular: number;
    medium: number;
    semibold: number;
    bold: number;
  };
  
  // Line Heights
  lineHeights: {
    none: number;
    tight: number;
    normal: number;
    relaxed: number;
    loose: number;
  };
}
```

## Theme Definition

### Theme Interface

```typescript
interface Theme {
  name: string;
  description?: string;
  tokens: ThemeTokens;
  variants?: ThemeVariants;
  
  // Theme Operations
  extend(tokens: Partial<ThemeTokens>): Theme;
  override(tokens: Partial<ThemeTokens>): void;
  
  // Token Management
  getToken(path: string): any;
  setToken(path: string, value: any): void;
}
```

### Theme Implementation

```typescript
class LightTheme implements Theme {
  constructor(options?: ThemeOptions);
  
  // Implementation
  tokens: ThemeTokens = {
    colors: {
      primary: {
        50: '#f0f9ff',
        100: '#e0f2fe',
        // ... other shades
      },
      // ... other color tokens
    },
    // ... other token categories
  };
}

class DarkTheme implements Theme {
  constructor(options?: ThemeOptions);
  // Dark theme implementation
}
```

## Theme Components

### Styled Components

```typescript
interface StyledOptions {
  theme?: Theme;
  variants?: ComponentVariants;
}

class StyledComponent {
  constructor(options: StyledOptions);
  
  // Styling Methods
  style(props: StyleProps): Styles;
  variant(name: string): Styles;
  
  // Theme Integration
  useTheme(): Theme;
  useToken(path: string): any;
}
```

### Component Variants

```typescript
interface ComponentVariants {
  // Variant Definitions
  size?: Record<string, Styles>;
  color?: Record<string, Styles>;
  variant?: Record<string, Styles>;
  state?: Record<string, Styles>;
}

interface Styles {
  // Style Properties
  [key: string]: string | number | Styles;
}
```

## Theme Plugins

### Plugin Interface

```typescript
interface ThemePlugin {
  name: string;
  
  // Plugin Operations
  install(theme: Theme): void;
  uninstall(theme: Theme): void;
  
  // Plugin Management
  configure(options: PluginOptions): void;
  isCompatible(theme: Theme): boolean;
}
```

### Plugin Implementations

```typescript
class ColorSchemePlugin implements ThemePlugin {
  constructor(options?: ColorSchemeOptions);
  
  // Implementation
  install(theme: Theme): void {
    // Add color scheme support
  }
}

class AnimationPlugin implements ThemePlugin {
  constructor(options?: AnimationOptions);
  // Animation plugin implementation
}
```

## Theme Tools

### Token Generator

```typescript
interface GeneratorOptions {
  base?: BaseTokens;
  scales?: ScaleOptions;
  output?: OutputOptions;
}

class TokenGenerator {
  constructor(options: GeneratorOptions);
  
  // Generation Methods
  generateColors(base: BaseColors): ColorTokens;
  generateTypography(base: BaseTypography): TypographyTokens;
  
  // Output Methods
  exportTokens(format: string): string;
  importTokens(data: string): ThemeTokens;
}
```

### Theme Builder

```typescript
interface BuilderOptions {
  base?: Theme;
  overrides?: ThemeOverrides;
  plugins?: ThemePlugin[];
}

class ThemeBuilder {
  constructor(options: BuilderOptions);
  
  // Building Methods
  addTokens(tokens: Partial<ThemeTokens>): this;
  addVariants(variants: ThemeVariants): this;
  addPlugin(plugin: ThemePlugin): this;
  
  // Output
  build(): Theme;
  preview(): ThemePreview;
}
```

## Implementation Notes

1. Token System
   - Scale generation
   - Token relationships
   - CSS variables
   - Fallback values

2. Performance
   - Dynamic updates
   - Style caching
   - Token resolution
   - CSS optimization

3. Customization
   - Theme extension
   - Component variants
   - Plugin system
   - Token overrides

4. Integration
   - CSS-in-JS
   - CSS Modules
   - Styled Components
   - CSS Custom Properties

5. Best Practices
   - Token naming
   - Scale consistency
   - Semantic usage
   - Documentation

## Testing Requirements

1. Theme Tests
   - Token resolution
   - Theme switching
   - Plugin system
   - Style generation

2. Component Tests
   - Theme integration
   - Variant application
   - Style updates
   - Token usage

3. Visual Tests
   - Color contrast
   - Typography scales
   - Spacing system
   - Component variants

4. Integration Tests
   - Framework compatibility
   - Plugin interactions
   - Style conflicts
   - Performance impact

## Usage Examples

### Basic Theme Setup

```typescript
const themeManager = new ThemeManager({
  themes: [
    new LightTheme(),
    new DarkTheme()
  ],
  defaultTheme: 'light'
});

// Switch theme
themeManager.setTheme('dark');

// Get current theme
const theme = themeManager.getTheme();
```

### Custom Theme Creation

```typescript
const customTheme = new ThemeBuilder({
  base: LightTheme
})
  .addTokens({
    colors: {
      primary: {
        500: '#0066cc'
      }
    }
  })
  .addVariants({
    button: {
      rounded: {
        borderRadius: '9999px'
      }
    }
  })
  .build();

themeManager.register(customTheme);
```

### Styled Component

```typescript
const Button = new StyledComponent({
  variants: {
    size: {
      sm: { padding: '0.5rem 1rem' },
      md: { padding: '1rem 2rem' },
      lg: { padding: '1.5rem 3rem' }
    },
    variant: {
      solid: {
        backgroundColor: 'primary.500',
        color: 'white'
      },
      outline: {
        borderColor: 'primary.500',
        color: 'primary.500'
      }
    }
  }
});

// Usage
const button = Button.style({
  size: 'md',
  variant: 'solid'
});
```

### Theme Plugin

```typescript
const colorScheme = new ColorSchemePlugin({
  preference: 'system',
  onChange: (scheme) => {
    themeManager.setTheme(
      scheme === 'dark' ? 'dark' : 'light'
    );
  }
});

themeManager.addPlugin(colorScheme);
```
