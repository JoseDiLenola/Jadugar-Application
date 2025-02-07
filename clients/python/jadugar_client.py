import uuid
import requests
from typing import Optional, Dict, Any

class JadugarError(Exception):
    def __init__(self, error_data: Dict[str, Any]):
        self.id = error_data.get('id')
        self.status = int(error_data.get('status', 500))
        self.code = error_data.get('code')
        self.title = error_data.get('title')
        self.detail = error_data.get('detail')
        self.source = error_data.get('source')
        self.meta = error_data.get('meta', {})
        self.links = error_data.get('links')

        # Platform-specific handling
        platform_specific = self.meta.get('platform_specific', {})
        self.handling_guide = platform_specific.get('handling_guide')
        self.recovery_suggestion = platform_specific.get('recovery_suggestion')

        super().__init__(self.title)

class JadugarClient:
    def __init__(self, base_url: str, api_key: Optional[str] = None, version: str = '1.0.0'):
        self.base_url = base_url.rstrip('/')
        self.api_key = api_key
        self.version = version
        self.platform = 'python'

    def request(self, endpoint: str, method: str = 'GET', **kwargs) -> Dict[str, Any]:
        url = f"{self.base_url}{endpoint}"
        headers = {
            'Content-Type': 'application/json',
            'X-Client-Platform': self.platform,
            'X-Client-Version': self.version,
            'X-Request-ID': str(uuid.uuid4())
        }

        if self.api_key:
            headers['Authorization'] = f'Bearer {self.api_key}'

        if 'headers' in kwargs:
            headers.update(kwargs.pop('headers'))

        try:
            response = requests.request(method, url, headers=headers, **kwargs)
            response.raise_for_status()
            return response.json()
        except requests.exceptions.HTTPError as e:
            if e.response is not None and e.response.headers.get('content-type', '').startswith('application/json'):
                error_data = e.response.json()
                if 'errors' in error_data and error_data['errors']:
                    raise JadugarError(error_data['errors'][0])
            raise
        except requests.exceptions.RequestException as e:
            error_data = {
                'status': '500',
                'code': 'NETWORK_ERROR',
                'title': 'Network request failed',
                'detail': str(e)
            }
            raise JadugarError(error_data)

# Example usage:
# client = JadugarClient('https://api.jadugar.com/v1', api_key='your-api-key')
# try:
#     result = client.request('/some-endpoint')
# except JadugarError as e:
#     print(f"{e.title}: {e.detail}")
#     if e.handling_guide:
#         print("Handling Guide:", e.handling_guide)
#     if e.recovery_suggestion:
#         print("Recovery Suggestion:", e.recovery_suggestion)
