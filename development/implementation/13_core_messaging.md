# @jadugar/core Messaging Layer

This document specifies the messaging layer implementation for the Jadugar project. The messaging layer provides a robust, scalable system for handling events, pub/sub, and message queues across the application.

## Message Architecture

### Message Manager

```typescript
interface MessageOptions {
  broker: 'rabbitmq' | 'kafka' | 'redis';
  url: string;
  exchange?: string;
  queue?: string;
  retryOptions?: RetryOptions;
  deadLetterOptions?: DeadLetterOptions;
}

class MessageManager {
  constructor(options: MessageOptions);
  
  // Connection Management
  async connect(): Promise<void>;
  async disconnect(): Promise<void>;
  async healthCheck(): Promise<HealthStatus>;
  
  // Basic Operations
  async publish(
    topic: string,
    message: Message,
    options?: PublishOptions
  ): Promise<void>;
  async subscribe(
    topic: string,
    handler: MessageHandler,
    options?: SubscribeOptions
  ): Promise<Subscription>;
  
  // Queue Operations
  async enqueue(
    queue: string,
    message: Message,
    options?: EnqueueOptions
  ): Promise<void>;
  async dequeue(
    queue: string,
    options?: DequeueOptions
  ): Promise<Message | null>;
  
  // Events
  on(event: MessageEvent, handler: EventHandler): this;
  off(event: MessageEvent, handler: EventHandler): this;
}
```

### Message Types

```typescript
interface Message {
  id: string;
  topic: string;
  payload: unknown;
  metadata: MessageMetadata;
  timestamp: number;
}

interface MessageMetadata {
  correlationId?: string;
  replyTo?: string;
  priority?: number;
  expiration?: number;
  headers?: Record<string, string>;
}

interface PublishOptions {
  persistent?: boolean;
  priority?: number;
  expiration?: number;
  headers?: Record<string, string>;
  retry?: RetryOptions;
}

interface SubscribeOptions {
  group?: string;
  autoAck?: boolean;
  prefetch?: number;
  retry?: RetryOptions;
  deadLetter?: DeadLetterOptions;
}
```

## Message Brokers

### Broker Interface

```typescript
interface MessageBroker {
  // Connection
  connect(): Promise<void>;
  disconnect(): Promise<void>;
  isConnected(): boolean;
  
  // Operations
  publish(topic: string, message: Message): Promise<void>;
  subscribe(
    topic: string,
    handler: MessageHandler
  ): Promise<Subscription>;
  
  // Queue Operations
  createQueue(name: string, options?: QueueOptions): Promise<void>;
  deleteQueue(name: string): Promise<void>;
  
  // Exchange Operations
  createExchange(
    name: string,
    options?: ExchangeOptions
  ): Promise<void>;
  deleteExchange(name: string): Promise<void>;
  
  // Binding Operations
  bind(
    queue: string,
    exchange: string,
    routingKey: string
  ): Promise<void>;
  unbind(
    queue: string,
    exchange: string,
    routingKey: string
  ): Promise<void>;
}
```

### RabbitMQ Implementation

```typescript
class RabbitMQBroker implements MessageBroker {
  constructor(options: RabbitMQOptions);
  
  // Connection Management
  async connect(): Promise<void>;
  async disconnect(): Promise<void>;
  
  // Channel Management
  async createChannel(): Promise<Channel>;
  async closeChannel(channel: Channel): Promise<void>;
  
  // Exchange Management
  async assertExchange(
    name: string,
    type: string,
    options?: ExchangeOptions
  ): Promise<void>;
  
  // Queue Management
  async assertQueue(
    name: string,
    options?: QueueOptions
  ): Promise<void>;
  
  // Message Operations
  async publish(
    exchange: string,
    routingKey: string,
    message: Message
  ): Promise<void>;
  async consume(
    queue: string,
    handler: MessageHandler
  ): Promise<Subscription>;
}
```

## Message Patterns

### Pub/Sub Pattern

```typescript
class PubSub {
  constructor(broker: MessageBroker);
  
  // Publisher
  async publish(
    topic: string,
    message: unknown,
    options?: PublishOptions
  ): Promise<void>;
  
  // Subscriber
  async subscribe(
    topic: string,
    handler: MessageHandler,
    options?: SubscribeOptions
  ): Promise<Subscription>;
  
  // Topic Management
  async createTopic(name: string): Promise<void>;
  async deleteTopic(name: string): Promise<void>;
  async listTopics(): Promise<string[]>;
}
```

### Request/Reply Pattern

```typescript
class RequestReply {
  constructor(broker: MessageBroker);
  
  // Client
  async request<T>(
    topic: string,
    payload: unknown,
    options?: RequestOptions
  ): Promise<T>;
  
  // Server
  async reply(
    topic: string,
    handler: RequestHandler,
    options?: ReplyOptions
  ): Promise<Subscription>;
  
  // Timeout Management
  setTimeout(timeout: number): void;
  setRetry(options: RetryOptions): void;
}
```

### Work Queue Pattern

```typescript
class WorkQueue {
  constructor(broker: MessageBroker);
  
  // Producer
  async enqueue(
    task: unknown,
    options?: EnqueueOptions
  ): Promise<void>;
  
  // Consumer
  async process(
    handler: TaskHandler,
    options?: ProcessOptions
  ): Promise<void>;
  
  // Queue Management
  async pause(): Promise<void>;
  async resume(): Promise<void>;
  async clear(): Promise<void>;
  
  // Monitoring
  getStatus(): QueueStatus;
  getMetrics(): QueueMetrics;
}
```

## Message Routing

### Router

```typescript
interface RouteOptions {
  pattern: string;
  handler: MessageHandler;
  middleware?: MessageMiddleware[];
}

class MessageRouter {
  constructor(broker: MessageBroker);
  
  // Route Registration
  route(options: RouteOptions): this;
  
  // Middleware
  use(middleware: MessageMiddleware): this;
  
  // Route Management
  removeRoute(pattern: string): this;
  clearRoutes(): this;
  
  // Route Execution
  handle(message: Message): Promise<void>;
}
```

### Middleware

```typescript
interface MessageMiddleware {
  (
    message: Message,
    next: () => Promise<void>
  ): Promise<void>;
}

class MiddlewareChain {
  constructor(middleware: MessageMiddleware[]);
  
  // Middleware Management
  use(middleware: MessageMiddleware): this;
  remove(middleware: MessageMiddleware): this;
  
  // Execution
  execute(message: Message): Promise<void>;
}
```

## Error Handling

### Dead Letter Handling

```typescript
interface DeadLetterOptions {
  exchange: string;
  queue: string;
  routingKey: string;
}

class DeadLetterHandler {
  constructor(broker: MessageBroker, options: DeadLetterOptions);
  
  // Message Handling
  async handle(message: Message, error: Error): Promise<void>;
  
  // Recovery
  async retry(messageId: string): Promise<void>;
  async retryAll(): Promise<void>;
  
  // Monitoring
  async getFailedMessages(): Promise<Message[]>;
  async getStats(): Promise<DeadLetterStats>;
}
```

### Retry Handling

```typescript
interface RetryOptions {
  attempts: number;
  delay: number;
  backoff?: BackoffStrategy;
  maxDelay?: number;
}

class RetryHandler {
  constructor(options: RetryOptions);
  
  // Retry Management
  async retry(
    operation: () => Promise<void>,
    context: RetryContext
  ): Promise<void>;
  
  // Backoff Calculation
  calculateDelay(attempt: number): number;
  
  // State Management
  reset(): void;
  getCurrentAttempt(): number;
}
```

## Implementation Notes

1. Message Configuration
   - Broker selection
   - Exchange/queue setup
   - Routing configuration
   - Error handling

2. Performance Optimization
   - Connection pooling
   - Message batching
   - Prefetch settings
   - Channel management

3. Reliability
   - Message persistence
   - Acknowledgments
   - Dead letter handling
   - Retry strategies

4. Monitoring
   - Queue depth
   - Processing rates
   - Error rates
   - Latency tracking

5. Security
   - Authentication
   - Authorization
   - Message encryption
   - Access control

## Testing Requirements

1. Broker Tests
   - Connection handling
   - Message delivery
   - Queue management
   - Error scenarios

2. Pattern Tests
   - Pub/sub messaging
   - Request/reply flows
   - Work queues
   - Message routing

3. Error Tests
   - Retry behavior
   - Dead letter handling
   - Timeout handling
   - Recovery scenarios

4. Performance Tests
   - Throughput
   - Latency
   - Concurrency
   - Resource usage

## Usage Examples

### Basic Pub/Sub

```typescript
const messaging = new MessageManager({
  broker: 'rabbitmq',
  url: process.env.RABBITMQ_URL
});

// Publisher
await messaging.publish('user.created', {
  id: 1,
  name: 'John'
});

// Subscriber
await messaging.subscribe(
  'user.created',
  async (message) => {
    console.log('User created:', message.payload);
  }
);
```

### Request/Reply Pattern

```typescript
const rpc = new RequestReply(messaging);

// Server
await rpc.reply('math.add', async (payload) => {
  const { a, b } = payload;
  return a + b;
});

// Client
const result = await rpc.request('math.add', { a: 1, b: 2 });
console.log('Result:', result); // 3
```

### Work Queue

```typescript
const queue = new WorkQueue(messaging);

// Producer
await queue.enqueue({
  type: 'email',
  to: 'user@example.com',
  subject: 'Welcome'
});

// Consumer
await queue.process(async (task) => {
  await sendEmail(task);
});
```

### Message Routing

```typescript
const router = new MessageRouter(messaging);

router.use(async (message, next) => {
  console.log('Processing message:', message.id);
  await next();
});

router.route({
  pattern: 'user.*',
  handler: async (message) => {
    await handleUserEvent(message);
  }
});
```
