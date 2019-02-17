import { start } from './lib/start'
import {NativeModules} from 'react-native';

console.log(NativeModules.Counter);

NativeModules.Counter.getCount(value => {
    console.log("Before: count is " + value)
})

NativeModules.Counter.increment();

NativeModules.Counter.getCount(value => {
    console.log("After: count is " + value)
})

start()
