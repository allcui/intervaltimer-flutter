enum RoundStates { end, warmUp, work, coolDown }

class RoundState{
  const RoundState({
    this.current,
    this.next,
    this.duration,
  });

  final RoundStates current;
  final RoundStates next;
  final Duration duration;
}