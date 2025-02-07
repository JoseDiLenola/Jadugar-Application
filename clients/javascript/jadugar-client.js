// Jadugar JavaScript Client

class JadugarClient {
  constructor(baseUrl, options = {}) {
    this.baseUrl = baseUrl;
    this.apiKey = options.apiKey;
    this.version = options.version || '1.0.0';
    this.platform = 'web';
  }

  async request(endpoint, options = {}) {
    const headers = {
      'Content-Type': 'application/json',
      'X-Client-Platform': this.platform,
      'X-Client-Version': this.version,
      'X-Request-ID': this.generateRequestId(),
      ...(this.apiKey && { 'Authorization': `Bearer ${this.apiKey}` }),
      ...options.headers
    };

    try {
      const response = await fetch(`${this.baseUrl}${endpoint}`, {
        ...options,
        headers
      });

      if (!response.ok) {
        const error = await response.json();
        throw this.handleError(error);
      }

      return await response.json();
    } catch (error) {
      if (error.isJadugarError) throw error;
      throw this.handleError({
        errors: [{
          status: '500',
          code: 'NETWORK_ERROR',
          title: 'Network request failed',
          detail: error.message
        }]
      });
    }
  }

  handleError(errorResponse) {
    const error = new Error();
    const errorData = errorResponse.errors[0];

    error.isJadugarError = true;
    error.id = errorData.id;
    error.status = parseInt(errorData.status, 10);
    error.code = errorData.code;
    error.title = errorData.title;
    error.detail = errorData.detail;
    error.source = errorData.source;
    error.meta = errorData.meta;
    error.links = errorData.links;

    // Add platform-specific handling
    if (errorData.meta?.platform_specific?.handling_guide) {
      error.handlingGuide = errorData.meta.platform_specific.handling_guide;
    }

    if (errorData.meta?.platform_specific?.recovery_suggestion) {
      error.recoverySuggestion = errorData.meta.platform_specific.recovery_suggestion;
    }

    return error;
  }

  generateRequestId() {
    return 'xxxxxxxx-xxxx-4xxx-yxxx-xxxxxxxxxxxx'.replace(/[xy]/g, (c) => {
      const r = (Math.random() * 16) | 0;
      const v = c === 'x' ? r : (r & 0x3) | 0x8;
      return v.toString(16);
    });
  }
}

// Example usage:
// const client = new JadugarClient('https://api.jadugar.com/v1');
// try {
//   const result = await client.request('/some-endpoint');
// } catch (error) {
//   if (error.isJadugarError) {
//     console.error(`${error.title}: ${error.detail}`);
//     if (error.handlingGuide) {
//       console.info('Handling Guide:', error.handlingGuide);
//     }
//   }
// }
