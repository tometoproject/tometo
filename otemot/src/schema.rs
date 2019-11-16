table! {
	avatars (id) {
		id -> Text,
		name -> Text,
		user_id -> Int4,
		pitch -> Int2,
		speed -> Float4,
		language -> Text,
		gender -> Text,
	}
}

table! {
	statuses (id) {
		id -> Text,
		content -> Text,
		avatar_id -> Text,
		related_status_id -> Nullable<Text>,
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

joinable!(avatars -> users (user_id));
joinable!(statuses -> avatars (avatar_id));

allow_tables_to_appear_in_same_query!(avatars, statuses, users,);
