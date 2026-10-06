import "@typespec/http";
import "@typespec/rest";

using TypeSpec.Http;
using TypeSpec.Rest;

@service({
  title: "Calendar Booking Service",
})
@server("https://calendar.local", "Main production server")
namespace CalendarBooking;

/** Тип события (встречи), создаваемый владельцем */
model EventType {
  @visibility("read")
  id: string;
  name: string;
  description: string;
  /** Длительность встречи в минутах */
  durationInMinutes: int32;
}

/** Сущность бронирования */
model Booking {
  @visibility("read")
  id: string;
  eventTypeId: string;
  /** Время начала бронирования */
  startTime: utcDateTime;
  /** Время окончания (рассчитывается на основе длительности типа события) */
  @visibility("read")
  endTime: utcDateTime;
  /** Данные гостя */
  guestName: string;
  guestEmail: string;
}

/** Запрос на создание бронирования от гостя */
model CreateBookingRequest {
  eventTypeId: string;
  /** Выбранное гостем время начала слота */
  startTime: utcDateTime;
  guestName: string;
  guestEmail: string;
}

/** Доступный для бронирования временной слот */
model AvailableSlot {
  startTime: utcDateTime;
  endTime: utcDateTime;
}

// ==========================================
// Интерфейс Владельца Календаря (Админ)
// ==========================================
@route("/admin")
@tag("Admin Operations")
interface AdminService {
  /** Создать новый тип события */
  @post
  @route("/event-types")
  createEventType(@body eventType: EventType): { @statusCode statusCode: 201, @body body: EventType } | ErrorResponse;

  /** Просмотреть все предстоящие бронирования по всем типам событий */
  @get
  @route("/bookings")
  listUpcomingBookings(): Booking[] | ErrorResponse;
}

// ==========================================
// Интерфейс Гостя
// ==========================================
@route("/")
@tag("Guest Operations")
interface GuestService {
  /** Получить список всех доступных видов брони (типов событий) */
  @get
  @route("/event-types")
  listEventTypes(): EventType[] | ErrorResponse;

  /** 
   * Получить сетку свободных слотов для конкретного типа события.
   * Возвращает слоты в рамках 14-дневного окна с учетом занятости.
   */
  @get
  @route("/event-types/{eventTypeId}/available-slots")
  getAvailableSlots(@path eventTypeId: string): AvailableSlot[] | ErrorResponse;

  /** 
   * Создать бронирование на выбранный слот.
   * Ошибка 409 возвращается, если слот уже занят другим бронированием.
   */
  @post
  @route("/bookings")
  createBooking(@body booking: CreateBookingRequest): { @statusCode statusCode: 201, @body body: Booking } | ConflictError | ErrorResponse;
}

// ==========================================
// Общие модели ошибок
// ==========================================
@error
model ErrorResponse {
  code: string;
  message: string;
}

/** Ошибка, возвращаемая при нарушении правила занятости (наложение слоев) */
@error
model ConflictError {
  @statusCode statusCode: 409;
  code: "SLOT_ALREADY_BOOKED";
  message: "Выбранное время уже занято другим бронированием.";
}
