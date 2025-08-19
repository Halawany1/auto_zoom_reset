# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.3] - 2024-08-19

### Fixed
- **CRITICAL FIX**: Completely rewrote scaling implementation using Transform.scale
- Child widget now properly scales as a complete unit (e.g., Container with fixed dimensions)
- Simplified gesture handling with direct scale factor management
- Removed complex Matrix4 calculations in favor of simple double scale values

### Changed
- Replaced ValueNotifier<Matrix4> with simple double _scale state management
- Improved setState() usage for proper widget rebuilding during zoom

## [1.0.2] - 2024-08-19

### Changed
- **BREAKING**: Replaced InteractiveViewer with GestureDetector + Transform approach
- Child widget is now scaled as a complete unit, not just its internal contents
- Zoom now applies to the entire child widget uniformly

### Fixed
- Fixed zoom behavior to scale the child widget itself rather than its contents
- Improved gesture handling for more intuitive zoom experience

## [1.0.1] - 2024-08-19

### Changed
- **BREAKING**: Removed unnecessary Container wrapper around child widget
- Child elements are now handled directly by InteractiveViewer for better performance
- Improved zoom handling to work directly with child components

### Fixed
- Optimized widget tree structure for better performance
- Reduced unnecessary widget nesting

## [1.0.0] - 2024-08-18

### Added
- Initial release of AutoZoomReset widget
- Automatic zoom reset functionality with customizable timing
- Smooth reset animations with configurable curves and duration
- Optional zoom indicator showing current scale percentage
- Comprehensive callback system for zoom events
- SimpleAutoZoomReset widget for minimal configuration
- Support for custom scale limits and boundary constraints
- Full platform support (iOS, Android, Web, Desktop)
- Extensive documentation and examples

### Features
- 🔄 Automatic reset to original scale and position
- ⏱️ Customizable reset delay and animation duration
- 🎨 Multiple animation curves (easeInOut, bounceOut, elasticOut, etc.)
- 📊 Optional visual zoom percentage indicator
- 🎯 Flexible configuration options
- 📱 Optimized touch and gesture handling
- 🚀 Lightweight and performant implementation
- 📦 Easy integration as InteractiveViewer replacement

### Documentation
- Comprehensive README with usage examples
- API documentation for all public methods
- Best practices and use case guidelines
- Platform-specific implementation notes
