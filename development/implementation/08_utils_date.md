# Date Utilities

This document specifies the date utilities for the Jadugar project. These utilities provide a comprehensive, type-safe system for handling dates, times, durations, and timezones across all packages.

## Core Date Types

### DateTime

```typescript
interface DateTime {
  readonly year: number;
  readonly month: number;
  readonly day: number;
  readonly hour: number;
  readonly minute: number;
  readonly second: number;
  readonly millisecond: number;
  readonly timezone: string;
  readonly timestamp: number;
}

interface DateTimeOptions {
  timezone?: string;
  locale?: string;
  calendar?: CalendarSystem;
}

class DateTime implements DateTime {
  static now(options?: DateTimeOptions): DateTime;
  static fromISO(text: string, options?: DateTimeOptions): DateTime;
  static fromTimestamp(timestamp: number, options?: DateTimeOptions): DateTime;
  static fromObject(obj: Partial<DateTime>, options?: DateTimeOptions): DateTime;
  
  toISO(options?: { includeOffset?: boolean }): string;
  toLocaleString(options?: Intl.DateTimeFormatOptions): string;
  toTimestamp(): number;
  
  plus(duration: Duration): DateTime;
  minus(duration: Duration): DateTime;
  startOf(unit: TimeUnit): DateTime;
  endOf(unit: TimeUnit): DateTime;
  
  diff(other: DateTime): Duration;
  until(other: DateTime): Interval;
  
  toUTC(): DateTime;
  toZone(timezone: string): DateTime;
  
  isValid(): boolean;
  invalidReason(): string | null;
}
```

### Duration

```typescript
type TimeUnit = 
  | 'year'
  | 'month'
  | 'week'
  | 'day'
  | 'hour'
  | 'minute'
  | 'second'
  | 'millisecond';

interface Duration {
  readonly years: number;
  readonly months: number;
  readonly weeks: number;
  readonly days: number;
  readonly hours: number;
  readonly minutes: number;
  readonly seconds: number;
  readonly milliseconds: number;
}

class Duration implements Duration {
  static fromObject(obj: Partial<Duration>): Duration;
  static fromISO(text: string): Duration;
  static fromMillis(milliseconds: number): Duration;
  
  toISO(): string;
  toFormat(format: string): string;
  toMillis(): number;
  toHuman(options?: { round?: boolean }): string;
  
  plus(duration: Duration): Duration;
  minus(duration: Duration): Duration;
  mapUnits(fn: (x: number) => number): Duration;
  
  normalize(): Duration;
  as(unit: TimeUnit): number;
  
  isValid(): boolean;
  invalidReason(): string | null;
}
```

### Interval

```typescript
interface Interval {
  readonly start: DateTime;
  readonly end: DateTime;
}

class Interval implements Interval {
  static fromISO(text: string): Interval;
  static fromDateTimes(start: DateTime, end: DateTime): Interval;
  static after(start: DateTime, duration: Duration): Interval;
  static before(end: DateTime, duration: Duration): Interval;
  
  length(unit?: TimeUnit): number;
  count(unit: TimeUnit): number;
  
  contains(dateTime: DateTime): boolean;
  overlaps(other: Interval): boolean;
  intersection(other: Interval): Interval | null;
  union(other: Interval): Interval;
  
  splitAt(...dateTimes: DateTime[]): Interval[];
  splitBy(duration: Duration): Interval[];
  divideEqually(parts: number): Interval[];
  
  toISO(): string;
  toString(): string;
  
  isValid(): boolean;
  invalidReason(): string | null;
}
```

## Calendar Systems

```typescript
type CalendarSystem = 
  | 'iso'
  | 'gregorian'
  | 'buddhist'
  | 'chinese'
  | 'coptic'
  | 'ethiopic'
  | 'hebrew'
  | 'indian'
  | 'islamic'
  | 'japanese'
  | 'persian';

interface CalendarDate {
  calendar: CalendarSystem;
  year: number;
  month: number;
  day: number;
}

class Calendar {
  static convert(
    date: CalendarDate,
    toCalendar: CalendarSystem
  ): CalendarDate;
  
  static isValid(date: CalendarDate): boolean;
  static daysInMonth(date: CalendarDate): number;
  static isLeapYear(date: CalendarDate): boolean;
}
```

## Timezone Handling

```typescript
interface TimezoneInfo {
  name: string;
  abbr: string;
  offset: number;
  isDST: boolean;
  population?: number;
}

class Timezone {
  static list(): string[];
  static load(timezone: string): TimezoneInfo;
  static guess(): string;
  
  static getOffset(timezone: string, date: DateTime): number;
  static getOffsetName(timezone: string, options?: { format?: 'long' | 'short' }): string;
  
  static isValid(timezone: string): boolean;
  static equals(zone1: string, zone2: string): boolean;
}
```

## Formatting and Parsing

```typescript
interface DateTimeFormatter {
  format(dateTime: DateTime): string;
  parse(text: string): DateTime;
}

class DateTimeFormat {
  static create(pattern: string, options?: DateTimeOptions): DateTimeFormatter;
  static createFromStyle(
    dateStyle?: 'full' | 'long' | 'medium' | 'short',
    timeStyle?: 'full' | 'long' | 'medium' | 'short'
  ): DateTimeFormatter;
  
  static extend(
    base: DateTimeFormatter,
    overrides: Partial<DateTimeOptions>
  ): DateTimeFormatter;
}
```

## Relative Time

```typescript
interface RelativeTimeOptions {
  locale?: string;
  style?: 'long' | 'short' | 'narrow';
  numeric?: 'always' | 'auto';
  round?: boolean;
  unit?: TimeUnit;
  padding?: number;
}

class RelativeTime {
  static format(
    dateTime: DateTime,
    options?: RelativeTimeOptions
  ): string;
  
  static toNow(
    dateTime: DateTime,
    options?: RelativeTimeOptions
  ): string;
  
  static fromNow(
    dateTime: DateTime,
    options?: RelativeTimeOptions
  ): string;
}
```

## Date Math and Calculations

```typescript
class DateMath {
  static min(...dates: DateTime[]): DateTime;
  static max(...dates: DateTime[]): DateTime;
  
  static clamp(
    date: DateTime,
    earliest: DateTime,
    latest: DateTime
  ): DateTime;
  
  static average(...dates: DateTime[]): DateTime;
  
  static sort(dates: DateTime[]): DateTime[];
  static unique(dates: DateTime[]): DateTime[];
  
  static isWeekend(date: DateTime): boolean;
  static isBusinessDay(date: DateTime): boolean;
  
  static addBusinessDays(date: DateTime, days: number): DateTime;
  static subtractBusinessDays(date: DateTime, days: number): DateTime;
  
  static businessDaysBetween(
    start: DateTime,
    end: DateTime
  ): number;
}
```

## Implementation Notes

1. All date operations should be immutable
2. Support for multiple calendar systems
3. Comprehensive timezone handling
4. Locale-aware formatting and parsing
5. High-precision calculations
6. Thread-safe operations
7. Memory-efficient date manipulations
8. Support for business calendar calculations

## Testing Requirements

1. Unit tests for all date operations
2. Timezone edge case testing
3. DST transition testing
4. Calendar system conversion tests
5. Formatting/parsing tests with various locales
6. Business calendar calculation tests
7. Performance tests for date math operations
8. Memory usage tests for large date sets

## Usage Examples

### Basic Date Operations

```typescript
const now = DateTime.now();
const tomorrow = now.plus({ days: 1 });
const nextWeek = now.plus({ weeks: 1 });

const duration = tomorrow.diff(now);
console.log(duration.toHuman()); // "1 day"
```

### Timezone Handling

```typescript
const nyTime = DateTime.now().toZone('America/New_York');
const tokyoTime = nyTime.toZone('Asia/Tokyo');
const offset = Timezone.getOffset('Asia/Tokyo', tokyoTime);
```

### Business Calendar

```typescript
const start = DateTime.fromISO('2025-01-01');
const end = DateTime.fromISO('2025-12-31');

const businessDays = DateMath.businessDaysBetween(start, end);
const nextBusinessDay = DateMath.addBusinessDays(start, 1);
```

### Relative Time

```typescript
const future = DateTime.now().plus({ months: 3 });
console.log(RelativeTime.fromNow(future)); // "in 3 months"

const past = DateTime.now().minus({ days: 5 });
console.log(RelativeTime.toNow(past)); // "5 days ago"
```
