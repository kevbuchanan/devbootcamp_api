# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130624180920) do

  create_table "actors", :force => true do |t|
    t.string   "name",        :null => false
    t.integer  "users_count", :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "cohort_id"
  end

  add_index "actors", ["cohort_id"], :name => "index_actors_on_cohort_id"

  create_table "actors_users", :force => true do |t|
    t.integer "actor_id", :null => false
    t.integer "user_id",  :null => false
  end

  add_index "actors_users", ["actor_id", "user_id"], :name => "index_actors_users_on_actor_id_and_user_id"

  create_table "challenge_attempts", :force => true do |t|
    t.integer  "actor_id",                   :null => false
    t.integer  "challenge_id",               :null => false
    t.string   "state",        :limit => 32, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.string   "repo"
    t.datetime "finished_at"
    t.integer  "cohort_id"
  end

  add_index "challenge_attempts", ["actor_id", "state"], :name => "index_challenge_attempts_on_actor_id_and_state"
  add_index "challenge_attempts", ["challenge_id"], :name => "index_challenge_attempts_on_challenge_id"
  add_index "challenge_attempts", ["cohort_id"], :name => "index_challenge_attempts_on_cohort_id"

  create_table "challenge_unit_categories", :force => true do |t|
    t.string   "title",       :limit => 32,                 :null => false
    t.datetime "created_at",                                :null => false
    t.datetime "updated_at",                                :null => false
    t.text     "description",               :default => ""
    t.integer  "priority",                  :default => 10
  end

  add_index "challenge_unit_categories", ["title"], :name => "index_challenge_unit_categories_on_title", :unique => true

  create_table "challenge_unit_dependencies", :force => true do |t|
    t.integer  "challenge_unit_id",          :null => false
    t.integer  "required_challenge_unit_id", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "challenge_unit_dependencies", ["challenge_unit_id", "required_challenge_unit_id"], :name => "index_challenge_unit_dependencies_on_dependent_required_id", :unique => true
  add_index "challenge_unit_dependencies", ["required_challenge_unit_id"], :name => "index_challenge_unit_dependencies_on_required_challenge_unit_id"

  create_table "challenge_units", :force => true do |t|
    t.string   "title",                                         :null => false
    t.integer  "challenge_unit_category_id",                    :null => false
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
    t.integer  "position",                                      :null => false
    t.boolean  "published",                  :default => true,  :null => false
    t.boolean  "locked",                     :default => false, :null => false
    t.integer  "weeks_until_available",      :default => 0,     :null => false
  end

  add_index "challenge_units", ["challenge_unit_category_id", "position"], :name => "index_challenge_units_on_challenge_unit_category_id_and_order", :unique => true
  add_index "challenge_units", ["title"], :name => "index_challenge_units_on_title", :unique => true

  create_table "challenges", :force => true do |t|
    t.integer  "actor_id",                             :null => false
    t.integer  "challenge_unit_id",                    :null => false
    t.boolean  "required",          :default => false, :null => false
    t.integer  "level",                                :null => false
    t.string   "name",                                 :null => false
    t.text     "description",                          :null => false
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.string   "source_repo"
    t.boolean  "draft",             :default => false
    t.integer  "prerequisite_id"
    t.boolean  "attempts_visible",  :default => true,  :null => false
  end

  add_index "challenges", ["actor_id"], :name => "index_challenges_on_actor_id"
  add_index "challenges", ["challenge_unit_id", "level", "required"], :name => "index_challenges_on_challenge_unit_id_and_level_and_required"
  add_index "challenges", ["name"], :name => "index_challenges_on_name", :unique => true
  add_index "challenges", ["prerequisite_id"], :name => "index_challenges_on_prerequisite_id"

  create_table "code_reviews", :force => true do |t|
    t.text     "body",                          :null => false
    t.integer  "actor_id",                      :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "comments_count", :default => 0
  end

  create_table "cohorts", :force => true do |t|
    t.string   "name"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
    t.boolean  "in_session", :default => false
    t.date     "start_date", :default => '2012-01-01', :null => false
    t.string   "location"
    t.string   "email"
    t.boolean  "visible",    :default => true
    t.string   "slug"
  end

  add_index "cohorts", ["name"], :name => "index_cohorts_on_name"
  add_index "cohorts", ["slug"], :name => "index_cohorts_on_slug", :unique => true
  add_index "cohorts", ["visible"], :name => "index_cohorts_on_visible"

  create_table "comments", :force => true do |t|
    t.integer  "commentable_id",   :default => 0
    t.string   "commentable_type", :default => ""
    t.string   "title",            :default => ""
    t.text     "body",             :default => ""
    t.string   "subject",          :default => ""
    t.integer  "user_id",          :default => 0,  :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
    t.datetime "created_at",                       :null => false
    t.datetime "updated_at",                       :null => false
    t.integer  "actor_id"
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "correct_exercise_attempts", :force => true do |t|
    t.integer  "user_id",             :null => false
    t.integer  "exercise_id",         :null => false
    t.integer  "exercise_attempt_id", :null => false
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  add_index "correct_exercise_attempts", ["exercise_id"], :name => "index_correct_exercise_attempts_on_exercise_id"
  add_index "correct_exercise_attempts", ["user_id", "exercise_id"], :name => "index_correct_exercise_attempts_on_user_id_and_exercise_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "exercise_attempts", :force => true do |t|
    t.integer  "exercise_id",                    :null => false
    t.text     "code",                           :null => false
    t.text     "results",                        :null => false
    t.boolean  "correct",     :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "actor_id",                       :null => false
  end

  add_index "exercise_attempts", ["correct"], :name => "index_exercise_attempts_on_correct"
  add_index "exercise_attempts", ["exercise_id", "actor_id", "correct"], :name => "index_exercise_attempts_on_exercise_id_and_actor_id_and_correct"
  add_index "exercise_attempts", ["exercise_id", "correct"], :name => "index_exercise_attempts_on_exercise_id_and_correct"

  create_table "exercises", :force => true do |t|
    t.text     "initial_code"
    t.text     "validator_code"
    t.text     "hint"
    t.text     "solution"
    t.text     "intro",                                                     :null => false
    t.datetime "created_at",                                                :null => false
    t.datetime "updated_at",                                                :null => false
    t.text     "wrapper_code"
    t.string   "title",          :limit => 100,                             :null => false
    t.string   "slug",           :limit => 8,                               :null => false
    t.string   "type",           :limit => 32,  :default => "RubyExercise", :null => false
    t.integer  "actor_id"
    t.string   "state",          :limit => 32,  :default => "unpublished",  :null => false
    t.datetime "published_at"
  end

  add_index "exercises", ["slug"], :name => "index_exercises_on_slug", :unique => true
  add_index "exercises", ["state"], :name => "index_exercises_on_state"
  add_index "exercises", ["type"], :name => "index_exercises_on_type"

  create_table "feed_items", :force => true do |t|
    t.integer  "actor_id",                    :null => false
    t.string   "feedable_type", :limit => 32, :null => false
    t.integer  "feedable_id",                 :null => false
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
  end

  add_index "feed_items", ["updated_at"], :name => "index_feed_items_on_updated_at"

  create_table "feedback", :force => true do |t|
    t.integer  "giver_id",                              :null => false
    t.integer  "receiver_id",                           :null => false
    t.text     "body"
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.integer  "poll_id"
    t.boolean  "viewable",    :default => false
    t.string   "state",       :default => "unreviewed"
  end

  add_index "feedback", ["giver_id"], :name => "index_feedback_on_giver_id"
  add_index "feedback", ["receiver_id"], :name => "index_feedback_on_receiver_id"

  create_table "feedback_questions", :force => true do |t|
    t.string   "body",       :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "feedback_ratings", :force => true do |t|
    t.integer  "user_id",           :null => false
    t.integer  "feedback_id",       :null => false
    t.integer  "kind_rating",       :null => false
    t.integer  "actionable_rating", :null => false
    t.integer  "specific_rating",   :null => false
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "feedback_ratings", ["feedback_id"], :name => "index_feedback_ratings_on_feedback_id"
  add_index "feedback_ratings", ["user_id", "feedback_id"], :name => "index_feedback_ratings_on_user_id_and_feedback_id"

  create_table "lab_chapters", :force => true do |t|
    t.integer  "lab_id",     :null => false
    t.integer  "position",   :null => false
    t.string   "slug",       :null => false
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "lab_chapters", ["lab_id", "position"], :name => "index_lab_chapters_on_lab_id_and_position"
  add_index "lab_chapters", ["lab_id", "slug"], :name => "index_lab_chapters_on_lab_id_and_slug", :unique => true

  create_table "lab_lessons", :force => true do |t|
    t.integer  "lab_chapter_id", :null => false
    t.integer  "position",       :null => false
    t.string   "slug",           :null => false
    t.string   "title",          :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.text     "content",        :null => false
  end

  add_index "lab_lessons", ["lab_chapter_id", "position"], :name => "index_lab_lessons_on_lab_chapter_id_and_position"
  add_index "lab_lessons", ["lab_chapter_id", "slug"], :name => "index_lab_lessons_on_lab_chapter_id_and_slug", :unique => true

  create_table "labs", :force => true do |t|
    t.string   "slug",       :null => false
    t.string   "title",      :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "labs", ["slug"], :name => "index_labs_on_slug", :unique => true
  add_index "labs", ["title"], :name => "index_labs_on_title", :unique => true

  create_table "polls_questions", :id => false, :force => true do |t|
    t.integer "poll_id",     :null => false
    t.integer "question_id", :null => false
  end

  add_index "polls_questions", ["poll_id", "question_id"], :name => "index_polls_questions_on_poll_id_and_question_id", :unique => true
  add_index "polls_questions", ["question_id"], :name => "index_polls_questions_on_question_id"

  create_table "posts", :force => true do |t|
    t.integer  "actor_id",                      :null => false
    t.text     "body",                          :null => false
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "comments_count", :default => 0
  end

  create_table "questions", :force => true do |t|
    t.text     "body",                          :null => false
    t.string   "state",                         :null => false
    t.integer  "actor_id",                      :null => false
    t.integer  "resolver_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "comments_count", :default => 0
  end

  create_table "responses", :force => true do |t|
    t.integer  "user_id",              :null => false
    t.integer  "feedback_question_id", :null => false
    t.integer  "rating",               :null => false
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
    t.integer  "feedback_id"
  end

  add_index "responses", ["feedback_question_id"], :name => "index_responses_on_question_id"
  add_index "responses", ["user_id"], :name => "index_responses_on_user_id"

  create_table "session_logs", :force => true do |t|
    t.integer  "actor_id", :null => false
    t.datetime "start_at", :null => false
    t.datetime "end_at"
  end

  add_index "session_logs", ["actor_id"], :name => "index_session_logs_on_actor_id"
  add_index "session_logs", ["start_at"], :name => "index_session_logs_on_start_at"

  create_table "sql_test_attempts", :force => true do |t|
    t.integer  "sql_test_id",                    :null => false
    t.text     "query",                          :null => false
    t.boolean  "correct",     :default => false, :null => false
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "actor_id"
    t.boolean  "expired",     :default => false
  end

  add_index "sql_test_attempts", ["correct"], :name => "index_sql_test_attempts_on_correct"
  add_index "sql_test_attempts", ["sql_test_id", "correct"], :name => "index_sql_test_attempts_on_sql_test_id_and_correct"

  create_table "sql_tests", :force => true do |t|
    t.string   "query",        :null => false
    t.string   "instructions", :null => false
    t.binary   "metadata"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "tasks", :force => true do |t|
    t.string   "title",                      :null => false
    t.text     "description"
    t.boolean  "mandatory",                  :null => false
    t.boolean  "response",                   :null => false
    t.integer  "position",    :default => 0, :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "tasks", ["position"], :name => "index_tasks_on_position"

  create_table "user_notes", :force => true do |t|
    t.integer  "user_id"
    t.text     "content"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "user_tasks", :force => true do |t|
    t.integer  "user_id"
    t.integer  "task_id"
    t.datetime "done_at"
    t.text     "response"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "user_tasks", ["user_id"], :name => "index_user_tasks_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at",                               :null => false
    t.datetime "updated_at",                               :null => false
    t.boolean  "pair_me",                :default => true
    t.integer  "cohort_id"
    t.string   "password_digest"
    t.integer  "roles_mask"
    t.text     "bio"
    t.datetime "last_emailed_at"
    t.string   "github_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.boolean  "show_console",           :default => true, :null => false
    t.datetime "deleted_at"
    t.text     "profile"
    t.datetime "disabled_at"
  end

  add_index "users", ["cohort_id"], :name => "index_users_on_cohort_id"
  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["roles_mask"], :name => "index_users_on_roles_mask"

  create_table "versions", :force => true do |t|
    t.string   "item_type",      :null => false
    t.integer  "item_id",        :null => false
    t.string   "event",          :null => false
    t.string   "whodunnit"
    t.text     "object"
    t.datetime "created_at"
    t.text     "object_changes"
  end

  add_index "versions", ["item_type", "item_id"], :name => "index_versions_on_item_type_and_item_id"

  create_table "weekly_retro_form_submissions", :force => true do |t|
    t.string   "uuid",         :limit => 20, :null => false
    t.text     "data",                       :null => false
    t.datetime "submitted_at",               :null => false
  end

end
