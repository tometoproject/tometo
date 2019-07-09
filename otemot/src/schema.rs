table! {
    statuses (id) {
        id -> Text,
        content -> Text,
        pitch -> Int4,
        user_id -> Int4,
    }
}

table! {
    users (id) {
        id -> Int4,
        email -> Text,
        username -> Text,
        password -> Text,
        created_at -> Timestamp,
        avatar -> Text,
    }
}

allow_tables_to_appear_in_same_query!(statuses, users,);
