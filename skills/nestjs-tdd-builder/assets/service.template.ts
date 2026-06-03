import { Injectable } from '@nestjs/common';

@Injectable()
export class ExampleService {
  async execute(): Promise<void> {
    // business behavior here
  }
}
