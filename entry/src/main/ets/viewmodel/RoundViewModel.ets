export class RoundViewModel {
  fastDuration: number = 10;
  slowDuration: number = 15;
  repetitions: number = 2;

  increaseFast(): void {
    this.fastDuration += 5;
  }

  decreaseFast(): void {
    if (this.fastDuration > 5) {
      this.fastDuration -= 5;
    }
  }

  increaseSlow(): void {
    this.slowDuration += 5;
  }

  decreaseSlow(): void {
    if (this.slowDuration > 5) {
      this.slowDuration -= 5;
    }
  }

  increaseReps(): void {
    this.repetitions += 1;
  }

  decreaseReps(): void {
    if (this.repetitions > 1) {
      this.repetitions -= 1;
    }
  }
}
