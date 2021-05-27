include "base.thrift"

namespace java com.rbkmoney.notification
namespace erlang notification

typedef string Base64
typedef string ContinuationToken
typedef base.ID PartyID
typedef base.ID NotificationTemplateId
typedef base.ID NotificationId

exception NotificationTemplateNotFound {}
exception BadContinuationToken { 1: string reason }

struct NotificationTemplate {
    1: required NotificationTemplateId id
    2: required string title
    3: required base.Timestamp created_at
    4: optional base.Timestamp updated_at
}

struct Notification {
    1: required NotificationId id
    2: required base.Timestamp created_at
    3: required Party party
    4: required NotificationTemplate template
    5: required NotificationStatus status
}

enum NotificationStatus {
    read
    unread
}

struct Party {
    1: required PartyID id
    2: required string name
}

union DateFilter {
    1: FixedDateFilter fixedDateFilter
    2: RangeDateFilter rangeDataFilter
}

struct FixedDateFilter {
    1: required base.Timestamp date
}

struct RangeDateFilter {
    2: required base.Timestamp from_date
    3: required base.Timestamp to_date
}

struct NotificationSearchRequest {
    1: optional string title
    2: optional DateFilter date
    3: optional NotificationStatus status
    4: optional PartyID partyId
    5: optional NotificationTemplateId notification_template_id
    6: optional ContinuationToken continuation_token
    7: optional i32 limit
}

struct NotificationSearchResponse {
    1: required list<Notification> result
    2: optional ContinuationToken continuation_token
}

struct NotificationTemplateSearchRequest {
    1: optional string title
    2: optional DateFilter date
    3: optional ContinuationToken continuation_token
    4: optional i32 limit
}

struct NotificationTemplateSearchResponse {
    1: required list<NotificationTemplate> result
    2: optional ContinuationToken continuation_token
}

struct PartySearchRequest {
    1: optional string name
    2: optional ContinuationToken continuation_token
    3: optional i32 limit
}

struct PartySearchResponse {
    1: required list<Party> result
    2: optional ContinuationToken continuation_token
}

struct NotificationCreateRequest {
    1: required string title
    2: required Base64 content
}

struct NotificationModifyRequest {
    1: required base.ID id
    2: optional string title
    3: optional Base64 content
}

service NotificationService {

    /* Создание шаблона уведомления */
    NotificationTemplate createNotificationTemplate(1: NotificationCreateRequest notification_request)
            throws (
                1: base.InvalidRequest ex1
            )

    /* Редактирование шаблона уведомления */
    NotificationTemplate modifyNotificationTemplate(1: NotificationModifyRequest notification_request)
            throws (
                1: base.InvalidRequest ex1,
                2: NotificationTemplateNotFound ex2
            )

    NotificationTemplate getNotificationTemplate(1: NotificationTemplateId template_id)
            throws (
                1: NotificationTemplateNotFound ex1
            )

    /* Поиск шаблонов уведомлений */
    list<NotificationTemplate> findNotificationTemplate(1: NotificationTemplateSearchRequest notification_search_request)
            throws (
                1: BadContinuationToken ex1
            )
    /* Поиск уведомлений */
    list<NotificationSearchResponse> findNotification(1: NotificationSearchRequest notification_search_request)
            throws (
                1: BadContinuationToken ex1
            )

    /* Отправка уведомления выбранным мерчантам */
    void sendNotification(1: NotificationTemplateId template_id, 2: list<PartyID> party_ids)

    /* Отправка уведомления для всех мерчантов */
    void sendNotificationAll(1: NotificationTemplateId template_id)

    /* Получение возможного списка мерчантов для отправки уведомлений */
    PartySearchResponse getParty(1: PartySearchRequest party_request)


}
