function __SimIterator() {
	callback(pos);
	++pos;
	if (pos < size) thread.PushNext(method(self, __SimIterator));
}