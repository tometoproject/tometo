defmodule Aph.QA do
  @moduledoc """
  Context module for Question and Answer-related things.
  """
  import Ecto.Query

  alias Aph.Repo

  alias Aph.QA.Answer
  alias Aph.QA.Comment
  alias Aph.QA.Inbox
  alias Aph.QA.Question
  alias Aph.TTS

  #
  # QUESTIONS
  #

  def get_question(id), do: Repo.get(Question, id)

  def create_question(attrs \\ {}) do
    changeset = %Question{} |> Question.changeset(attrs)
    Repo.insert(changeset)
  end

  #
  # ANSWERS
  #

  def get_answer(id) do
    answer = Repo.one(from(a in Answer, where: a.id == ^id, preload: [:avatar, :question]))
    Map.merge(answer, format_answer_for_display(answer))
  end

  def format_answer_for_display(%Answer{} = answer) do
    hostname = Application.get_env(:aph, :hostname)
    avatar = answer.avatar
    audio_path = "#{hostname}/static/aw-#{answer.id}.ogg"
    timestamps_path = "#{hostname}/static/aw-#{answer.id}.json"
    pic1_path = "#{hostname}/static/av#{avatar.id}-1.png"
    pic2_path = "#{hostname}/static/av#{avatar.id}-2.png"

    %{
      audio: audio_path,
      timestamps: timestamps_path,
      pic1: pic1_path,
      pic2: pic2_path
    }
  end

  def create_answer(av, attrs \\ {}) do
    changeset = %Answer{} |> Answer.changeset(attrs)
    {:ok, answer} = Repo.insert(changeset)

    with :ok <- TTS.synthesize(answer, "aw", av),
         :ok <- TTS.clean("aw-#{answer.id}") do
      {:ok, answer}
    else
      {:tts_error, err} ->
        Repo.delete!(answer)
        {:error, "Error while generating Text-to-speech audio: #{err}!"}
    end
  end

  def update_answer(%Answer{} = answer, attrs) do
    answer
    |> Answer.changeset(attrs)
    |> Repo.update()
  end

  def delete_answer(%Answer{} = answer) do
    Repo.delete(answer)
  end

  #
  # INBOXES
  #

  def get_inbox(id), do: Repo.get(Inbox, id)

  def get_inbox_for_user(user_id) do
    Repo.all(
      from(i in Inbox,
        where: i.user_id == ^String.to_integer(user_id),
        where: not i.answered,
        preload: :question
      ),
      preload: :question
    )
  end

  def create_inbox(attrs \\ {}) do
    changeset = %Inbox{} |> Inbox.creation_changeset(attrs)
    Repo.insert(changeset)
  end

  def update_inbox(%Inbox{} = inbox, attrs) do
    inbox
    |> Inbox.changeset(attrs)
    |> Repo.update()
  end

  def delete_inbox(%Inbox{} = inbox) do
    Repo.delete(inbox)
  end

  #
  # COMMENTS
  #

  def get_comment(id), do: Repo.get(Comment, id)

  def get_comments_for_answer(answer_id) do
    comments = Repo.all(from(c in Comment, where: c.answer_id == ^answer_id, preload: :avatar))
    Enum.map(comments, fn c -> Map.merge(c, format_comment_for_display(c)) end)
  end

  def format_comment_for_display(%Comment{} = comment) do
    hostname = Application.get_env(:aph, :hostname)
    avatar = comment.avatar
    audio_path = "#{hostname}/static/cm-#{comment.id}.ogg"
    timestamps_path = "#{hostname}/static/cm-#{comment.id}.json"
    pic1_path = "#{hostname}/static/av#{avatar.id}-1.png"
    pic2_path = "#{hostname}/static/av#{avatar.id}-2.png"

    %{
      audio: audio_path,
      timestamps: timestamps_path,
      pic1: pic1_path,
      pic2: pic2_path
    }
  end

  def create_comment(av, attrs \\ {}) do
    changeset = %Comment{} |> Comment.changeset(attrs)
    {:ok, comment} = Repo.insert(changeset)

    with :ok <- TTS.synthesize(comment, "cm", av),
         :ok <- TTS.clean("cm-#{comment.id}") do
      {:ok, comment}
    else
      {:tts_error, err} ->
        Repo.delete!(comment)
        {:error, "Error while generating Text-to-speech audio: #{err}!"}
    end
  end

  def update_comment(%Comment{} = comment, attrs) do
    comment
    |> Comment.update_changeset(attrs)
    |> Repo.update()
  end

  def delete_comment(%Comment{} = comment) do
    Repo.delete(comment)
  end
end
