enum SubmissionStatus { initial, loading, success, failure }

class SubmissionStatusState {
  final SubmissionStatus status;
  final String? message;

  SubmissionStatusState({this.status = SubmissionStatus.initial, this.message});

  SubmissionStatusState copyWith({SubmissionStatus? status, String? message}) {
    return SubmissionStatusState(
      status: status ?? this.status,
      message: message ?? this.message,
    );
  }
}
