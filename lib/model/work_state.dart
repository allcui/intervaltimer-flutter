enum WorkStates { work, rest }

class WorkState{
  const WorkState({
    this.current,
    this.next,
    this.duration,
  });

  final WorkStates current;
  final WorkStates next;
  final Duration duration;
}